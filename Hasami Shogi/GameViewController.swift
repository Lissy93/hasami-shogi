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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.itemSize = CGSize(width: 30, height: 30)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 80
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("WAAAT - Hasami Shogi is now complete");
        print(indexPath);
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            cell.backgroundColor = UIColor.greenColor()
            print(cell.textInputContextIdentifier )
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.orangeColor()
        cell.targetForAction("getAction:", withSender: self)
        return cell
    }
    
    func getAction(sender:UITableViewCell)->Void {
        if(sender.tag == 0) {
            print("it worked") // this will never be called, because nothing never works, BECAUSE SWIFT IS STUPID
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpGrid () {
        let grid = UICollectionView();
        grid
    }

    
}

