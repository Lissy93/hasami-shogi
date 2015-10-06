//
//  Player.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 04/10/2015.
//  Copyright © 2015 Alicia Sykes. All rights reserved.
//

import Foundation

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