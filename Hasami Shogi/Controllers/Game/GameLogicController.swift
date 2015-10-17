//
//  GameLogicController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 04/10/2015.
//  Copyright © 2015 Alicia Sykes. All rights reserved.
//

import UIKit

class GameLogic {
    
    var player1 = Player(playerNum: PlayerNum.player1, playerName: "Alicia", moves: 0, playerTurn: true)
    var player2 = Player(playerNum: PlayerNum.player2, playerName: "LIZZARD", moves: 0, playerTurn: false)
    
    let blackChecker = "black_checker.png"
    let whiteChecker = "white_checker.png"

    
    // Finds a list of cell cordinates where the user can valid move to
    func findPossibleMoves(cellCordinates: CellCordinates, collectionView: UICollectionView) -> [CellCordinates] {

        var cellsToMark: [CellCordinates] = []

        func isCellBelowValid(currentCell: CellCordinates){
            if let theCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentCell.y, inSection: currentCell.x-1)) as! GameCell?{
                if(theCell.cellStatus == .empty){
                    cellsToMark.append(theCell.cellCordinates)
                    isCellBelowValid(theCell.cellCordinates)
                }
            }
        }
        
        func isCellAboveValid(currentCell: CellCordinates){
            if let theCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentCell.y, inSection: currentCell.x+1)) as! GameCell?{
                if(theCell.cellStatus == .empty){
                    cellsToMark.append(theCell.cellCordinates)
                    isCellAboveValid(theCell.cellCordinates)
                }
            }
        }
        
        func isCellToRightValid(currentCell: CellCordinates){
            if let theCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentCell.y-1, inSection: currentCell.x)) as! GameCell?{
                if(theCell.cellStatus == .empty){
                    cellsToMark.append(theCell.cellCordinates)
                    isCellToRightValid(theCell.cellCordinates)
            
                }
            }
        }
        
        func isCellToLeftValid(currentCell: CellCordinates){
            if let theCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentCell.y+1, inSection: currentCell.x)) as! GameCell?{
                if(theCell.cellStatus == .empty){
                    cellsToMark.append(theCell.cellCordinates)
                    isCellToLeftValid(theCell.cellCordinates)
                }
            }
        }
        
        isCellAboveValid(cellCordinates)
        isCellToRightValid(cellCordinates)
        isCellBelowValid(cellCordinates)
        isCellToLeftValid(cellCordinates)
        
        return cellsToMark
    }
    
    
    // Add Checker to Cell
    func placePiece(cell: GameCell, player: PlayerNum){
        
        cell.cellStatus = player // And add reference in the new cell

        let image = UIImage(named: (player == PlayerNum.player1) ? blackChecker : whiteChecker)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cell.addSubview(imageView)
    }
    
    
    // Remove Checker from Cell
    func removePiece(cell: GameCell){
        // Remove image
        for subview in cell.subviews {
            if subview is UIImageView { subview.removeFromSuperview() }
        }
        // Reset reference
        cell.cellStatus = .empty // Remove reference to old cell
    }
    
    
    // Marks a cell with a dot
    func putDotInGrid(cell: GameCell){
        let image = UIImage(named: "cell_marker.png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 10, y: 10, width: 10, height: 10)
        cell.addSubview(imageView)
        cell.containsDot = true
    }
    
    
    // Removes all does from cells after move has been made
    func removeAllDotsFromCells(collectionView: UICollectionView){
        for cell in collectionView.visibleCells() as! [GameCell] {
            if cell.containsDot{
            for subview in cell.subviews {
                if subview is UIImageView { subview.removeFromSuperview() }
                }
                cell.containsDot = false
            }
        }
    
    }
    
    
    // Add an outline to cell to indicate piece has been selected
    func pickUpCell(cell: GameCell){
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.redColor().CGColor
        cell.pickedUp = true
    }
    
    
    // Removes the outline and resets the picked up reference
    func putDownCell(cell: GameCell){
        cell.layer.borderWidth = 0
        cell.pickedUp = false
    }
    
    
    // Has a user picked up a piece and waiting to put it down
    func isCellPickedUp(collectionView: UICollectionView) -> Bool {
        for potentialCell in collectionView.visibleCells() as! [GameCell] {
            if(potentialCell.pickedUp){
                return true
            }
        }
        return false
    }
    
    
    // Gets the GameCell currently being moved
    func getCurrentlyMovingCell(collectionView: UICollectionView) -> GameCell?{
        var startCell: GameCell?
        for potentialCell in collectionView.visibleCells() as! [GameCell] {
            if(potentialCell.pickedUp){ startCell = potentialCell; break }
        }
        return startCell
    }
    
    
    // Change which players turn it is
    func changePlayer(lastPlayerNum: PlayerNum){
        if player1.playerNum == lastPlayerNum{
            player1.playerTurn = false
            player2.playerTurn = true
        }
        else if player2.playerNum == lastPlayerNum{
            player2.playerTurn = false
            player1.playerTurn = true
        }
    }
    
    
    // Returns the player number for whoever's turn it is
    func getCurrentPlayer() -> Player{
        return (player1.playerTurn) ? player1 : player2 ;
    }
    
    
    // Who's the enemy?
    func getEnemyPlayerNum() -> PlayerNum{
        return (getCurrentPlayer().playerNum == .player1) ? .player2 : .player1

    }
    
    
    // Get Player object from playerNum
    func getPlayerFromPlayerNum(playerNum: PlayerNum) -> Player{
        return (playerNum == .player1) ? player1 : player2
    }
    
    
    // Looks to see if a checker is sucessfully surrounded
    func checkIfPieceShouldBeTaken(newCellCordinates: CellCordinates, collectionView: UICollectionView){
        
        let enemy = getEnemyPlayerNum()
        let ally = getCurrentPlayer()
        
        func checkForKill(firstCordinates: CellCordinates, nextCordinates: CellCordinates){
            if let firstCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: firstCordinates.y, inSection: firstCordinates.x)) as! GameCell?{
                if firstCell.cellStatus == enemy{
                    if let nextCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: nextCordinates.y, inSection: nextCordinates.x)) as! GameCell?{
                        if nextCell.cellStatus == ally.playerNum{
                            removePiece(firstCell) // Destroy Enemy
                        }
                    }
                }
            }
        }

        checkForKill(
            CellCordinates(x: newCellCordinates.x-1, y: newCellCordinates.y),
            nextCordinates: CellCordinates(x: newCellCordinates.x-2, y: newCellCordinates.y))
        checkForKill(
            CellCordinates(x: newCellCordinates.x+1, y: newCellCordinates.y),
            nextCordinates: CellCordinates(x: newCellCordinates.x+2, y: newCellCordinates.y))
        checkForKill(
            CellCordinates(x: newCellCordinates.x, y: newCellCordinates.y-1),
            nextCordinates: CellCordinates(x: newCellCordinates.x, y: newCellCordinates.y-2))
        checkForKill(
            CellCordinates(x: newCellCordinates.x, y: newCellCordinates.y+1),
            nextCordinates: CellCordinates(x: newCellCordinates.x, y: newCellCordinates.y+2))
    }
    
    
    // Determines if a player has won by number of pieces left on grid
    func checkForWin(collectionView: UICollectionView) -> PlayerNum{
        var player1Count: Int = 0, player2Count: Int = 0
        for cell in collectionView.visibleCells() as! [GameCell] {
            if cell.cellStatus == .player1{ player1Count++ }
            else if cell.cellStatus == .player2{ player2Count++ }
        }
        if player1Count <= 1 { return .player1}
        else if player2Count <= 1{ return .player2}
        else{ return .empty}
    }
    
        
    // Calls the functions required to actually move a piece and update all attributes
    func makeMove (fromCell: GameCell, toCell: GameCell, player: Player, collectionView: UICollectionView){
        removeAllDotsFromCells(collectionView) // Remove all blue placeholder dots
        putDownCell(fromCell) // Put first cell back down
        removePiece(fromCell) // Remove old piece and reset reference
        placePiece(toCell, player: player.playerNum) // Add piece to new cell
        checkIfPieceShouldBeTaken(toCell.cellCordinates, collectionView: collectionView)
        changePlayer(player.playerNum) // Change who's turn it is
    }

    
}