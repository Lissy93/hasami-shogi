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
    

    var gameLogic = GameLogic() // Contains all the logic for playing the game
    var gameStatusTexts = [String: UITextField]() // Stores a list of text fields for displaying various game status's
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ggv: GenerateGameView = GenerateGameView(gvc: self) 
        ggv.createElements() // Set up the game board
        gameStatusTexts["playerTurn"] = ggv.playerStatus
        gameStatusTexts["playerStatus"] = ggv.playerPieceCount
        updatePlayerTurnText()
        updatePlayerStatusText()
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
                    playPickupSound()
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
                        updatePlayerTurnText()
                        let winStatus = gameLogic.checkForWin(gameCollectionView)
                        if winStatus != .empty{
                            gameWon(winStatus)
                            playVictoryMusic()
                        }
                        updatePlayerStatusText(gameCollectionView)
                        playPutdownSound()
                    }
                }

            }
            
            
        }
    }

    
    func updatePlayerTurnText(){
        gameStatusTexts["playerTurn"]!.text = gameLogic.getCurrentPlayer().playerName + "'s Turn"
    }
    
    
    func updatePlayerStatusText(gameCollectionView: UICollectionView){
        gameStatusTexts["playerStatus"]!.text =
            "\(gameLogic.player1.playerName)': \(gameLogic.howMangePiecesLeft(.player1, collectionView: gameCollectionView)) \t\t\t\t\t \(gameLogic.player2.playerName): \(gameLogic.howMangePiecesLeft(.player2, collectionView: gameCollectionView))"
    }
    
    func updatePlayerStatusText(){
        gameStatusTexts["playerStatus"]!.text =
        "\(gameLogic.player1.playerName): 9 \t\t\t\t\t \(gameLogic.player2.playerName): 9"
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

    // Display Game Won message
    func gameWon(winner: PlayerNum){
        
        let title = "Game Won!"
        let message = gameLogic.getPlayerFromPlayerNum(winner).playerName + " won the game!"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let newGameAction = UIAlertAction(title: "New Game", style: .Default) { (action) in
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            self.viewWillAppear(true)
            self.viewDidLoad()

        }
        alertController.addAction(newGameAction)
        
        let highScoresAction = UIAlertAction(title: "High Scoress", style: .Default) { (action) in

        }
        alertController.addAction(highScoresAction)
        
        self.presentViewController(alertController, animated: true) {}
    }
    
    
    func playPickupSound(){
        if let pickupSoundUrl = NSBundle.mainBundle().URLForResource("pickup", withExtension: "mp3") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(pickupSoundUrl, &mySound)
            AudioServicesPlaySystemSound(mySound); // Play sound
        }
    }
    
    func playPutdownSound(){
        if let putdownSound = NSBundle.mainBundle().URLForResource("putdown", withExtension: "mp3") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(putdownSound, &mySound)
            AudioServicesPlaySystemSound(mySound); // Play sound
        }
    }
    
    func playVictoryMusic(){
        if let winSound = NSBundle.mainBundle().URLForResource("win-music", withExtension: "mp3") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(winSound, &mySound)
            AudioServicesPlaySystemSound(mySound); // Play sound
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

