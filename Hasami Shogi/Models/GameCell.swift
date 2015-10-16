//
//  GameCell.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 10/10/2015.
//  Copyright © 2015 Alicia Sykes. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    var cellCordinates: CellCordinates! // Will be assigned after creation
    var cellStatus: PlayerNum = .empty  // Does the cell have a piece in it?
    var pickedUp: Bool = false          // Is the pice currently being moved?
    var containsDot: Bool = false       // Is this cell marked as a valid move
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setters
    
    func setCordinates(cordinates: CellCordinates) {
        self.cellCordinates = cordinates
    }
    
    // Retures a UIColor for the cell background
    func getCellBackgroundCol() -> (UIColor){
        
        // Game Square Colour Constants
        let darkerSquare  = UIColor(red: 0.85, green: 0.85, blue: 0.95, alpha: 0.8)
        let lighterSquare = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        
        // Return a colour based on wheather even or odd square
        return (((cellCordinates.y % 2 == 0) ?
            cellCordinates.x : cellCordinates.x+1)  % 2 == 0) ?
                lighterSquare : darkerSquare
    }
    
    
    
}



struct CellCordinates{
    var x: Int
    var y: Int
}
