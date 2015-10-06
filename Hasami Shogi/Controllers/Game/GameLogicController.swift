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
    
    var player2 = Player(playerNum: PlayerNum.player2, playerName: "Ollie", moves: 0, piecePositions: [72, 73, 74, 75, 76, 77, 78, 79, 80])
    

    // Method called when a cell is pressed
    func cellPressed(cell: UICollectionViewCell, cellIndex: Int){
////        if player1.piecePositions.contains(cellIndex){
//            findPossibleMoves(cellIndex)
////        }
//        
//        
//        
//        
//        putDotInGrid(cell)
    }
    
    // Places dots on the squares the user could move to
    func findPossibleMoves(cellIndex: Int) -> [Int] {
        
        // Find coloumn and row number
        let colNum = cellIndex % 9
        let rowNum = cellIndex / 9
        
        var cellsToMark: [Int] = []
        
        // Find list of cells within row and co number
        for index in 0..<9 { cellsToMark.append(colNum + index*9) }
        for index in rowNum*9..<rowNum*9+9 { cellsToMark.append(index) }
        
        
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