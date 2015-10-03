//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 25/09/2015.
//  Copyright (c) 2015 Alicia Sykes. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var gameGrid: UICollectionView!
    
    var player1 = Player(playerNum: PlayerNum.player1, playerName: "Alicia", moves: 0, piecePositions: [0,1,2,3,4,5,6,7,8])
    var player2 = Player(playerNum: PlayerNum.player2, playerName: "Ollie", moves: 0, piecePositions: [72, 73, 74, 75, 76, 77, 78, 79, 80])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.itemSize = CGSize(width: 31, height: 31)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        
        gameGrid = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        gameGrid.dataSource = self
        gameGrid.delegate = self
        gameGrid.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        gameGrid.backgroundColor = UIColor.whiteColor()
        
        let gameHeaderView = UIView()
        gameHeaderView.translatesAutoresizingMaskIntoConstraints = false
        let title: UITextField = UITextField (frame:CGRectMake(10, 25, 120, 20));
        title.text = "Hasami Shogi"
        gameHeaderView.addSubview(title)
        
        
        gameGrid.translatesAutoresizingMaskIntoConstraints = false

        
//        view.backgroundColor = UIColor(
//            red: 0.9,
//            green: 0.9,
//            blue: 1,
//            alpha: 1.0)
        
        //Add the views
        view.addSubview(gameHeaderView)
        view.addSubview(gameGrid)
        
        
        let viewsDictionary = [
            "view1":gameHeaderView,
            "view2":gameGrid]
        
        let metricsDictionary = [
            "view1Height": 50.0,
            "view2Height":40.0,
            "viewWidth": 290.0 ]

        
        let view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[view2]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        let view_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-36-[view1]-8-[view2]-0-|",
            options: NSLayoutFormatOptions.AlignAllLeading,
            metrics: nil, views: viewsDictionary)
        
        view.addConstraints(view_constraint_H)
        view.addConstraints(view_constraint_V)
        
        
        // Game Score View
        let view1_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[view1(viewWidth)]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: metricsDictionary,
            views: viewsDictionary)
        let view1_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[view1(view1Height)]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: metricsDictionary,
            views: viewsDictionary)
        
        gameHeaderView.addConstraints(view1_constraint_H)
        gameHeaderView.addConstraints(view1_constraint_V)
        // Game Grid View
        let view2_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[view2(viewWidth)]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: metricsDictionary,
            views: viewsDictionary)
        let view2_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[view2(>=view2Height)]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: metricsDictionary, 
            views: viewsDictionary)
        
        gameGrid.addConstraints(view2_constraint_H)
        gameGrid.addConstraints(view2_constraint_V)
        
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
        cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8) : UIColor(red: 0.85, green: 0.85, blue: 0.95, alpha: 0.8)

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

