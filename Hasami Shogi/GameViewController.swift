//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 25/09/2015.
//  Copyright (c) 2015 Alicia Sykes. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    
    var player1 = Player(playerNum: PlayerNum.player1, playerName: "Alicia", moves: 0, piecePositions: [0,1,2,3,4,5,6,7,8])
    var player2 = Player(playerNum: PlayerNum.player2, playerName: "Ollie", moves: 0, piecePositions: [72, 73, 74, 75, 76, 77, 78, 79, 80])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.itemSize = CGSize(width: 26, height: 26)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
           placePiece(cell, player: player1.playerNum)
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
    }
    
    func placePiece(cell: UICollectionViewCell, player: PlayerNum){
        cell.backgroundColor = (player == PlayerNum.player1) ? UIColor.greenColor() : UIColor.blueColor()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.orangeColor()
        cell.targetForAction("getAction:", withSender: self)
        if player1.piecePositions.contains(indexPath.item){
            placePiece(cell, player: player1.playerNum)
        }
        else if player2.piecePositions.contains(indexPath.item){
            placePiece(cell, player: player2.playerNum)
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

struct Player {
    var playerNum: PlayerNum
    var playerName: String
    var moves: Int
    var piecePositions: [Int]
    
    mutating func makeMove(from: Int, to: Int){
        // Remove old piece position
        if let index = piecePositions.indexOf(from){
            piecePositions.removeAtIndex(index)
        }
        
        // Add in new piece position
        piecePositions.append(to)
        
        moves++
    }
    
}

enum PlayerNum {
    case player1
    case player2
}

