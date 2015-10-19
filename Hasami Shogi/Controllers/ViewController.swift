//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 25/09/2015.
//  Copyright (c) 2015 Alicia Sykes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func newGamePressed(sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }

    @IBAction func howToPlayPressed(sender: UIButton) {
        
        let playText = "Two players take turn to move their pieces one at a time." +
            "Pieces can be moved any number of squares either vertically or " +
            "horizontally, but can’y jump. Just as a rook in chess. \n" +
            "The objective of the game is to capture the opponents pieces, " +
            "this can be done by surrounding one of their pieces with two of " +
            "your’s to enclose it either horizontally or vertically."
        
        
        let alertController = UIAlertController(title: "How to Play", message: playText, preferredStyle: .Alert)
        
        let gotItAction = UIAlertAction(title: "Got It", style: .Default) { (action) in }
        alertController.addAction(gotItAction)
        
        let startTheGameAction = UIAlertAction(title: "Start the Game", style: .Default) { (action) in
            self.tabBarController?.selectedIndex = 1
        }
        alertController.addAction(startTheGameAction)
        
        self.presentViewController(alertController, animated: true) {}
    }
    
    
    @IBAction func leagueTablePressed(sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
    
    @IBAction func usersPressed(sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func settingsPressed(sender: UIButton) {
        self.tabBarController?.selectedIndex = 4
    }

}

