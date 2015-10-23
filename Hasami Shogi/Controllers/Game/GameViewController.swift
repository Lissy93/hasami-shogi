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
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let gameStatus = GameStatusController() // Contains methods for updating all status information

    let gameLogic = GameLogic() // Contains all the logic for playing the game
    
    let defaults = NSUserDefaults.standardUserDefaults() // The user settings

    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameStatus.showStartDialog(self)
        
        let ggv: GenerateGameView = GenerateGameView(gvc: self) 
        ggv.createElements() // Set up the game board
        gameStatus.gameStatusTexts["playerTurn"] = ggv.playerStatus
        gameStatus.gameStatusTexts["playerStatus"] = ggv.playerPieceCount
        updatePlayerTurnText(gameStatus.gameStatusTexts["playerTurn"]!)
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
                    gameStatus.playSound(.pickup)
                }
                else{gameStatus.playSound(.invalid)}
        

                
            }
            else{ // A cell is currently picked up and needs to be moved
                // Find currently picked up cell from last move
                let startCell: GameCell? = gameLogic.getCurrentlyMovingCell(gameCollectionView)
                
                // Put cell back down if pressed again
                if(startCell == cell){
                    gameLogic.putDownCell(startCell!)
                    gameLogic.removeAllDotsFromCells(gameCollectionView)
                }
                
                // Check it's a valid move
                if let confirmedStartCell = startCell{
                    let startPossiblePositions = gameLogic.findPossibleMoves(confirmedStartCell.cellCordinates, collectionView: gameCollectionView)
                    let found = startPossiblePositions.filter{$0.x == cell.cellCordinates.x && $0.y == cell.cellCordinates.y}.count > 0
                    if  (found){
                        gameLogic.makeMove(confirmedStartCell, toCell: cell, player: gameLogic.getCurrentPlayer(), collectionView: gameCollectionView)
                        updatePlayerTurnText(gameStatus.gameStatusTexts["playerTurn"]!)
                        let winStatus = gameLogic.checkForWin(gameCollectionView)
                        if winStatus != .empty{
                            gameStatus.gameWon(winStatus, gvc: self)
                            gameStatus.playSound(.victory)
                        }
                        
                        var fiveRowToWin = false
                        if let tryFiveInRowToWin: Bool = defaults.boolForKey("fiveInARowToWin") {
                            fiveRowToWin = tryFiveInRowToWin
                        }
                        
                        if(fiveRowToWin){
                            let fiveWinStatus = gameLogic.checkForFiveInRow(gameCollectionView, cell: cell)
                            if fiveWinStatus != .empty{
                                gameStatus.gameWon(fiveWinStatus, gvc: self)
                                gameStatus.playSound(.victory)
                            }
                        }
                        
                        
                        gameStatus.updatePlayerStatusText(gameCollectionView)
                        gameStatus.playSound(.putdown)
                    }
                    else{gameStatus.playSound(.invalid)}
                }

            }
            
            
        }
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        // Set up the cells
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GameCell
        cell.setCordinates(CellCordinates(x:indexPath.section, y:indexPath.item))
        cell.backgroundColor = cell.getCellBackgroundCol()
        
        var twoRows: Bool
        
        //Get the number of starting pieces and set
        if let numStartingPieces: Int = defaults.integerForKey("numOfStartingPieces") {
            twoRows = numStartingPieces == 18 ? true : false
        }
        else{twoRows = false }
        
        
        // Place the players pieces
        if(cell.cellCordinates.y == 0){
            gameLogic.placePiece(cell, player: .player1)
        }
        if(cell.cellCordinates.y == 8){
            gameLogic.placePiece(cell, player: .player2)
        }
        
        // If there are 2 starting rows, then place additional pieces
        if twoRows{
            if(cell.cellCordinates.y == 1){
                gameLogic.placePiece(cell, player: .player1)
            }
            if(cell.cellCordinates.y == 7){
                gameLogic.placePiece(cell, player: .player2)
            }
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Calls the restart game method when the restart button is pressed
    func buttonAction(sender:UIButton!){
        gameStatus.restartGame(self)
    }
    
    // Updates the text field which indicates which players turn it is
    func updatePlayerTurnText(playerTurnText: UITextField){
        playerTurnText.text = gameLogic.getCurrentPlayer().playerName + "'s Turn"
    }

    
}

