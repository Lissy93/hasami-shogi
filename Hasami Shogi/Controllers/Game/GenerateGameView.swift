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
        
        // Create the Game Score View
        let gameHeaderView = UIView()
        gameHeaderView.translatesAutoresizingMaskIntoConstraints = false
        let title: UITextField = UITextField (frame:CGRectMake(10, 25, 120, 20));
        title.text = "Hasami Shogi"
        gameHeaderView.addSubview(title)
        
        
        // Add the Game Score View and the Game View to main view
        gvc.view.addSubview(gameHeaderView)
        gvc.view.addSubview(gameGrid)
        
        // Add Constraints
        if let constraints = applyConstraints([ "view1":gameHeaderView, "view2":gameGrid]){
            
            gvc.view.addConstraints(constraints.mainConstraints_H)
            gvc.view.addConstraints(constraints.mainConstraints_V)
            
            gameHeaderView.addConstraints(constraints.headerConstraints_H)
            gameHeaderView.addConstraints(constraints.headerConstraints_V)
            
            gameGrid.addConstraints(constraints.gameConstraints_H)
            gameGrid.addConstraints(constraints.gameConstraints_V)
        }
    
    }

    // Apply layout constraints to new view
    func applyConstraints(viewsDictionary: Dictionary<String,UIView>) -> (
        mainConstraints_H: [NSLayoutConstraint], mainConstraints_V: [NSLayoutConstraint],
        headerConstraints_H: [NSLayoutConstraint], headerConstraints_V: [NSLayoutConstraint],
        gameConstraints_H: [NSLayoutConstraint], gameConstraints_V: [NSLayoutConstraint])? {
            
            var mc_H, mc_V, hc_H, hc_V, gc_H, gc_V: [NSLayoutConstraint] // Results to return
            
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
            
            mc_H = view_constraint_H
            mc_V = view_constraint_V
            
            
            // Game Score View Contstraints
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
                "V:[view2(>=view2Height)]",
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: metricsDictionary,
                views: viewsDictionary)
            
            gc_H = view2_constraint_H
            gc_V = view2_constraint_V
            
            return (mc_H, mc_V, hc_H, hc_V, gc_H, gc_V)
    }

}