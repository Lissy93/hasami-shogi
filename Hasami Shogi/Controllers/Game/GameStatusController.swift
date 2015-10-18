//
//  GameStatusController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 04/10/2015.
//  Copyright © 2015 Alicia Sykes. All rights reserved.
//

import UIKit
import AVFoundation


class GameStatusController{
    
    let gameLogic =  GameLogic()
    var gameStatusTexts = [String: UITextField]() // Stores a list of text fields for displaying various game status's

    
    // Updates the text field which indicates which players turn it is
    func updatePlayerTurnText(){
        gameStatusTexts["playerTurn"]!.text = gameLogic.getCurrentPlayer().playerName + "'s Turn"
    }
    
    
    // Updates the upper text fieeld indicating how many pieces each player has remaining
    func updatePlayerStatusText(gameCollectionView: UICollectionView){
        gameStatusTexts["playerStatus"]!.text =
        "\(gameLogic.player1.playerName)': \(gameLogic.howMangePiecesLeft(.player1, collectionView: gameCollectionView)) \t\t\t\t\t \(gameLogic.player2.playerName): \(gameLogic.howMangePiecesLeft(.player2, collectionView: gameCollectionView))"
    }
    
    
    // Initially updates the text field indicating how many pieces each player is startign with
    func updatePlayerStatusText(){
        gameStatusTexts["playerStatus"]!.text =
        "\(gameLogic.player1.playerName): 9 \t\t\t\t\t \(gameLogic.player2.playerName): 9"
    }
    

    // Display Game Won message
    func gameWon(winner: PlayerNum, gvc: GameViewController){
        
        let title = "Game Won!"
        let message = gameLogic.getPlayerFromPlayerNum(winner).playerName + " won the game!"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let newGameAction = UIAlertAction(title: "New Game", style: .Default) { (action) in
            self.restartGame(gvc)
            
        }
        alertController.addAction(newGameAction)
        
        let highScoresAction = UIAlertAction(title: "High Scoress", style: .Default) { (action) in
            
        }
        alertController.addAction(highScoresAction)
        
        gvc.presentViewController(alertController, animated: true) {}
    }
    
    
    // Plays a sound when a checker is pickec up
    func playPickupSound(){
        if let pickupSoundUrl = NSBundle.mainBundle().URLForResource("pickup", withExtension: "mp3") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(pickupSoundUrl, &mySound)
            AudioServicesPlaySystemSound(mySound); // Play sound
        }
    }
    
    
    // Plays a sound when a checker is put back down
    func playPutdownSound(){
        if let putdownSound = NSBundle.mainBundle().URLForResource("putdown", withExtension: "mp3") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(putdownSound, &mySound)
            AudioServicesPlaySystemSound(mySound); // Play sound
        }
    }
    
    
    // Plays a sound when the game is won
    func playVictoryMusic(){
        if let winSound = NSBundle.mainBundle().URLForResource("win-music", withExtension: "mp3") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(winSound, &mySound)
            AudioServicesPlaySystemSound(mySound); // Play sound
        }
    }
    
    
    // Calls the restart game method when the restart button is pressed
    func buttonAction(sender:UIButton!, gvc: GameViewController){
        restartGame(gvc)
    }
    
    
    // Restarts the game
    func restartGame(gvc: GameViewController){
        gvc.view.subviews.forEach({ $0.removeFromSuperview() })
        gvc.viewWillAppear(true)
        gvc.viewDidLoad()
    }
    

}
