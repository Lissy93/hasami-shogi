//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 25/09/2015.
//  Copyright (c) 2015 Alicia Sykes. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    
    let gameStatus = GameStatusController() // Contains methods for updating all status information

    let gameLogic = GameLogic() // Contains all the logic for playing the game
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ggv: GenerateGameView = GenerateGameView(gvc: self) 
        ggv.createElements() // Set up the game board
        gameStatus.gameStatusTexts["playerTurn"] = ggv.playerStatus
        gameStatus.gameStatusTexts["playerStatus"] = ggv.playerPieceCount
        gameStatus.updatePlayerTurnText()
        gameStatus.updatePlayerStatusText()
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
    
    
    func collectionView(gameCollectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = gameCollectionView.cellForItemAtIndexPath(indexPath) as! GameCell?{
            
            if (!gameLogic.isCellPickedUp(gameCollectionView)){
            
                if (cell.cellStatus == gameLogic.getCurrentPlayer().playerNum){
                    gameLogic.pickUpCell(cell)
                    let possiblePositions = gameLogic.findPossibleMoves(cell.cellCordinates, collectionView: gameCollectionView)
                    for eachCellCordinates in possiblePositions{
                        let currentCell = gameCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: eachCellCordinates.y, inSection: eachCellCordinates.x)) as! GameCell
                        gameLogic.putDotInGrid(currentCell)
                    }
                    gameStatus.playPickupSound()
                }
        

                
            }
            else{ // A cell is currently picked up and needs to be moved
                // Find currently picked up cell from last move
                let startCell: GameCell? = gameLogic.getCurrentlyMovingCell(gameCollectionView)
                
                // Check it's a valid move
                if let confirmedStartCell = startCell{
                    let startPossiblePositions = gameLogic.findPossibleMoves(confirmedStartCell.cellCordinates, collectionView: gameCollectionView)
                    let found = startPossiblePositions.filter{$0.x == cell.cellCordinates.x && $0.y == cell.cellCordinates.y}.count > 0
                    if  (found){
                        gameLogic.makeMove(confirmedStartCell, toCell: cell, player: gameLogic.getCurrentPlayer(), collectionView: gameCollectionView)
                        gameStatus.updatePlayerTurnText()
                        let winStatus = gameLogic.checkForWin(gameCollectionView)
                        if winStatus != .empty{
                            gameStatus.gameWon(winStatus, gvc: self)
                            gameStatus.playVictoryMusic()
                        }
                        gameStatus.updatePlayerStatusText(gameCollectionView)
                        gameStatus.playPutdownSound()
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
    
    
}

