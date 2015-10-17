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
    var playerTurn: Bool
    
}

enum PlayerNum {
    case player1
    case player2
    case empty
}