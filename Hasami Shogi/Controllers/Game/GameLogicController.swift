//
//  GameLogicController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 04/10/2015.
//  Copyright © 2015 Alicia Sykes. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


class GameLogic {
    
    var player1 = Player(playerNum: PlayerNum.player1, playerName: "Player 1", id: 0, playerTurn: true )
    var player2 = Player(playerNum: PlayerNum.player2, playerName: "Player 2", id: 0, playerTurn: false)
    
    let blackChecker = "black_checker.png"
    let whiteChecker = "white_checker.png"
    
    let um = UserManagement()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init(){
        resetPlayers()
    }
    
    func resetPlayers(){
        player1 = um.getPlayers(.player1)
        player2 = um.getPlayers(.player2)
    }
    
    
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
    
    
    // Plays a sound when piece is taken
    func playPieceTakenSound(){
        if(defaults.boolForKey("enableSound")){
            if let takenSound = NSBundle.mainBundle().URLForResource("die", withExtension: "mp3") {
                var mySound: SystemSoundID = 0
                AudioServicesCreateSystemSoundID(takenSound, &mySound)
                AudioServicesPlaySystemSound(mySound); // Play sound
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
        return (player1.playerTurn) ? um.getPlayers(.player1) : um.getPlayers(.player2) ;
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
                            playPieceTakenSound()
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
    
    
    // Gets number of peices left for certain player
    func howMangePiecesLeft(playerNum: PlayerNum, collectionView: UICollectionView) -> Int{
        var pieceCount: Int = 0
        for cell in collectionView.visibleCells() as! [GameCell] {
            if cell.cellStatus == playerNum{ pieceCount++ }
        }
        return pieceCount
    }
    
    // Determines if a player has won by number of pieces left on grid
    func checkForWin(collectionView: UICollectionView) -> PlayerNum{
        let piecesToWin = defaults.integerForKey("numPiecesRemainingToWin")
        let player1Count = howMangePiecesLeft(.player1, collectionView: collectionView)
        let player2Count = howMangePiecesLeft(.player2, collectionView: collectionView)
        if player1Count <= piecesToWin { return .player2}
        else if player2Count <= piecesToWin{ return .player1}
        else{ return .empty}
    }
    
    func checkForFiveInRow(collectionView: UICollectionView, cell: GameCell) ->PlayerNum{
        
        // TODO either implement this method, or kill whoever invented this stupid game rule
        
        let startCellCoordinates = cell.cellCordinates
        
        func checkLineForFive(theLine: [PlayerNum]) -> PlayerNum{
            var pl1 = 0, pl2 = 0
            for square: PlayerNum in theLine{
                if square == .player1{
                    pl1++
                    pl2 = 0
                }
                else if square == .player2{
                    pl2++
                    pl1 = 0
                }
                else{
                    pl1 = 0
                    pl2 = 0
                }
                if(pl1 >= 5){ return .player1}
                if(pl2 >= 5){ return .player2}
            }
            return .empty
        }
        
        func buildUpCellListVertically(rowNum: Int) ->[PlayerNum]{
            var results: [PlayerNum] = []
            func isInRow(gc: GameCell) -> Bool {
                return gc.cellCordinates.x == rowNum ? true : false
            }
            
            var rowCells = (collectionView.visibleCells() as! [GameCell]).filter(isInRow)
            rowCells = rowCells.sort({ $0.cellCordinates.y > $1.cellCordinates.y })
            
            for rowCell in rowCells { results.append(rowCell.cellStatus) }
            return results
        }
        
        func buildUpCellListHorizontally(colNum: Int) ->[PlayerNum]{

            var numOfStartingPieces = 9
            if let numStartingPiecesDefault: Int = defaults.integerForKey("numOfStartingPieces") {
                numOfStartingPieces = numStartingPiecesDefault
            }
            if(numOfStartingPieces == 18 && (colNum == 1 || colNum == 7)){ return [] }
            if(colNum == 0 || colNum == 8){ return [] }
            
            var results: [PlayerNum] = []
            func isInCol(gc: GameCell) -> Bool {
                return gc.cellCordinates.y == colNum ? true : false
            }
            
            var colCells = (collectionView.visibleCells() as! [GameCell]).filter(isInCol)
            colCells = colCells.sort({ $0.cellCordinates.x > $1.cellCordinates.x })
            
            for colCell in colCells { results.append(colCell.cellStatus) }
            return results
        }
        
        func buildUpCellListDiganolly() ->[PlayerNum]{
            // this is stupid
            return []
        }
        
        let vertically = checkLineForFive(buildUpCellListVertically(startCellCoordinates.x))
        let horizontally = checkLineForFive(buildUpCellListHorizontally(startCellCoordinates.y))

        
        if(vertically != .empty){ return vertically}
        if(horizontally != .empty){ return horizontally}
        
        return .empty

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