//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 25/09/2015.
//  Copyright (c) 2015 Alicia Sykes. All rights reserved.
//

import UIKit

class GameViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    

    var gameLogic = GameLogic() // Contains all the logic for playing the game
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ggv: GenerateGameView = GenerateGameView(gvc: self) 
        ggv.createElements() // Set up the game board
    }
    
    // Set number of cells per row for game grid
    func collectionView(collectionView: UICollectionView,
            numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    // Set number of rows for game grid
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 9
    }
    
    // Set the custom GameCell for the UICollectionViewCell
    func dequeueReusableCellWithReuseIdentifier(identifier: String,
        forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
    return GameCell()
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GameCell?{

            let cellCordinates = cell.cellCordinates
            
            let possiblePositions = gameLogic.findPossibleMoves(cellCordinates, collectionView: collectionView)
            
            for eachCellCordinates in possiblePositions{
                let currentCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: eachCellCordinates.y, inSection: eachCellCordinates.x))
                gameLogic.putDotInGrid(currentCell!)
            }
        
            
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GameCell
        cell.setCordinates(CellCordinates(x:indexPath.section, y:indexPath.item))
        cell.backgroundColor = cell.getCellBackgroundCol()
        
        // Place the players pieces
        if(cell.cellCordinates.y == 0){
            cell.cellStatus = .player1
            gameLogic.placePiece(cell, player: .player1)
        }
        if(cell.cellCordinates.y == 8){
            cell.cellStatus = .player2
            gameLogic.placePiece(cell, player: .player2)
        }

//        if gameLogic.player1.piecePositions.contains(indexPath.item){
//            gameLogic.placePiece(cell, player: gameLogic.player1.playerNum)
//        }
//        else if gameLogic.player2.piecePositions.contains(indexPath.item){
//            gameLogic.placePiece(cell, player: gameLogic.player2.playerNum)
//        }
        
        print(cell.cellCordinates)
        
        return cell
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpGrid () {
        let grid = UICollectionView();
        grid
    }
    
}

