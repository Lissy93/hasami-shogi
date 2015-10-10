//
//  GameLogicController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 04/10/2015.
//  Copyright © 2015 Alicia Sykes. All rights reserved.
//

import UIKit

class GameLogic {
    
    var player1 = Player(playerNum: PlayerNum.player1, playerName: "Alicia", moves: 0, piecePositions: [0,1,2,3,4,5,6,7,8])
    
    var player2 = Player(playerNum: PlayerNum.player2, playerName: "LIZZARD", moves: 0, piecePositions: [72, 73, 74, 75, 76, 77, 78, 79, 80])
    

    // Method called when a cell is pressed
    func cellPressed(cell: UICollectionViewCell, cellIndex: Int){

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
    
    func getIndexPathFromCellNumber(cellNum: Int) -> NSIndexPath{
        return NSIndexPath(forRow: cellNum / 9, inSection: cellNum % 9)
    }
    
    
    // Add Piece to Grid
    func placePiece(cell: UICollectionViewCell, player: PlayerNum){
        let blackChecker = "black_checker.png"
        let whiteChecker = "white_checker.png"
        let image = UIImage(named: (player == PlayerNum.player1) ? blackChecker : whiteChecker)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cell.addSubview(imageView)
    }
    
    // Marks a cell with a dot
    func putDotInGrid(cell: UICollectionViewCell){
        let image = UIImage(named: "cell_marker.png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 10, y: 10, width: 10, height: 10)
        cell.addSubview(imageView)
    }
    

}