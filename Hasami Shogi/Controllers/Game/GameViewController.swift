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
            
            if (!gameLogic.isCellPickedUp(collectionView)){
            
                if (cell.cellStatus == gameLogic.getCurrentPlayer().playerNum){
                    gameLogic.pickUpCell(cell)
                    let possiblePositions = gameLogic.findPossibleMoves(cell.cellCordinates, collectionView: collectionView)
                    for eachCellCordinates in possiblePositions{
                        let currentCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: eachCellCordinates.y, inSection: eachCellCordinates.x)) as! GameCell
                        gameLogic.putDotInGrid(currentCell)

                    }
                }
            }
            else{ // A cell is currently picked up and needs to be moved
                // Find currently picked up cell from last move
                let startCell: GameCell? = gameLogic.getCurrentlyMovingCell(collectionView)
                
                // Check it's a valid move
                if let confirmedStartCell = startCell{
                    let startPossiblePositions = gameLogic.findPossibleMoves(confirmedStartCell.cellCordinates, collectionView: collectionView)
                    let found = startPossiblePositions.filter{$0.x == cell.cellCordinates.x && $0.y == cell.cellCordinates.y}.count > 0
                    if  (found){
                        gameLogic.makeMove(confirmedStartCell, toCell: cell, player: gameLogic.getCurrentPlayer(), collectionView: collectionView)
                        
                    }
                }

            }
            
            
        }
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Set up the cells
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GameCell
        cell.setCordinates(CellCordinates(x:indexPath.section, y:indexPath.item))
        cell.backgroundColor = cell.getCellBackgroundCol()
        
        // Place the players pieces
        if(cell.cellCordinates.y == 0){
            gameLogic.placePiece(cell, player: .player1)
        }
        if(cell.cellCordinates.y == 8){
            gameLogic.placePiece(cell, player: .player2)
        }
        
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

