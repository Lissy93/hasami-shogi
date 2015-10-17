//
//  GenerateGameView.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 04/10/2015.
//  Copyright © 2015 Alicia Sykes. All rights reserved.
//

import UIKit

class GenerateGameView {

    var gameGrid: UICollectionView!
    let gvc: GameViewController
    
    let playerStatus: UITextField = UITextField (frame:CGRectMake(0, 25, 290, 50));
    let playerPieceCount: UITextField = UITextField (frame:CGRectMake(0, 0, 290, 50))

    
    init(gvc: GameViewController){
        self.gvc = gvc
    }
    
    
    func createElements(){
        // Create the layout for the Game Grid
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.itemSize = CGSize(width: 31, height: 31)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        
        // Create the Game Grid
        gameGrid = UICollectionView(frame: gvc.view.frame, collectionViewLayout: layout)
        gameGrid.dataSource = gvc
        gameGrid.delegate = gvc
        gameGrid.registerClass(GameCell.self, forCellWithReuseIdentifier: "Cell")
        gameGrid.backgroundColor = UIColor.whiteColor()
        gameGrid.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the Game Header View
        let gameHeaderView = UIView()
        gameHeaderView.translatesAutoresizingMaskIntoConstraints = false
        playerPieceCount.font = UIFont (name: "HelveticaNeue-UltraLight", size: 16)
        playerPieceCount.text = ""
        gameHeaderView.addSubview(playerPieceCount)
        
        // Create the Next Player View
        let playerTurnView = UIView()
        playerTurnView.translatesAutoresizingMaskIntoConstraints = false
        playerStatus.text = ""
        playerStatus.textAlignment = .Center
        playerStatus.font = UIFont (name: "HelveticaNeue-UltraLight", size: 30)
        playerTurnView.addSubview(playerStatus)
        
        
        // Add the Game Score View and the Game View to main view
        gvc.view.addSubview(gameHeaderView)
        gvc.view.addSubview(gameGrid)
        gvc.view.addSubview(playerTurnView)
        
        // Add Constraints
        if let constraints = applyConstraints([ "view1":gameHeaderView, "view2":gameGrid, "view3":playerTurnView]){
            
            gvc.view.addConstraints(constraints.mainConstraints_H)
            gvc.view.addConstraints(constraints.mainConstraints_V)
            
            gameHeaderView.addConstraints(constraints.headerConstraints_H)
            gameHeaderView.addConstraints(constraints.headerConstraints_V)
            
            gameGrid.addConstraints(constraints.gameConstraints_H)
            gameGrid.addConstraints(constraints.gameConstraints_V)
            
            playerTurnView.addConstraints(constraints.playerTurnConstraints_H)
            playerTurnView.addConstraints(constraints.playerTurnConstraints_V)
        }
        
    }

    // Apply layout constraints to new view
    func applyConstraints(viewsDictionary: Dictionary<String,UIView>) -> (
        mainConstraints_H: [NSLayoutConstraint], mainConstraints_V: [NSLayoutConstraint],
        headerConstraints_H: [NSLayoutConstraint], headerConstraints_V: [NSLayoutConstraint],
        gameConstraints_H: [NSLayoutConstraint], gameConstraints_V: [NSLayoutConstraint],
        playerTurnConstraints_H: [NSLayoutConstraint], playerTurnConstraints_V: [NSLayoutConstraint])? {
            
            var mc_H, mc_V, hc_H, hc_V, gc_H, gc_V, pt_H, pt_V: [NSLayoutConstraint] // Results to return
            
            let metricsDictionary = [
                "view1Height": 50.0,
                "view2Height":300.0,
                "view3Height":30.0,
                "viewWidth": 290.0 ]
            
            let view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[view2]",
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: nil, views: viewsDictionary)
            let view_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-36-[view1]-8-[view2]-0-[view3]|",
                options: NSLayoutFormatOptions.AlignAllLeading,
                metrics: nil, views: viewsDictionary)
            
            mc_H = view_constraint_H
            mc_V = view_constraint_V
            
            
            // Game Header View Contstraints
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
            
            hc_H = view1_constraint_H
            hc_V = view1_constraint_V
            
            // Game Grid View Constraints
            let view2_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[view2(viewWidth)]",
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: metricsDictionary,
                views: viewsDictionary)
            let view2_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[view2(view2Height)]",
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: metricsDictionary,
                views: viewsDictionary)
            
            gc_H = view2_constraint_H
            gc_V = view2_constraint_V
            
            
            // Player Turn View Constraints
            let view3_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[view3(viewWidth)]",
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: metricsDictionary,
                views: viewsDictionary)
            let view3_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[view3(>=view3Height)]",
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: metricsDictionary,
                views: viewsDictionary)
            
            pt_H = view3_constraint_H
            pt_V = view3_constraint_V
            
            return (mc_H, mc_V, hc_H, hc_V, gc_H, gc_V, pt_H, pt_V)
    }

}