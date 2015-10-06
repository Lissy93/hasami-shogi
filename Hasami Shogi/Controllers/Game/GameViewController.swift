//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 25/09/2015.
//  Copyright (c) 2015 Alicia Sykes. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    

    var gameLogic = GameLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ggv: GenerateGameView = GenerateGameView(gvc: self)
        ggv.startSetup()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            
            // Does cell currently have a piece in it
            let cellIndex = indexPath.item
//            if gameLogic.player1.piecePositions.contains(cellIndex){
//                
//            }

//           gameLogic.cellPressed(cell, cellIndex: cellIndex)
            
            
            let possiblePositions = gameLogic.findPossibleMoves(cellIndex)
            
            for cellNum in possiblePositions{
                var currentCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: cellNum, inSection: 0))
                gameLogic.putDotInGrid(currentCell!)
            }
        
            
            
            
            
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8) : UIColor(red: 0.85, green: 0.85, blue: 0.95, alpha: 0.8)

        cell.targetForAction("getAction:", withSender: self)
        if gameLogic.player1.piecePositions.contains(indexPath.item){
            gameLogic.placePiece(cell, player: gameLogic.player1.playerNum)
        }
        else if gameLogic.player2.piecePositions.contains(indexPath.item){
            gameLogic.placePiece(cell, player: gameLogic.player2.playerNum)
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

