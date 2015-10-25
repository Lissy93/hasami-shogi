//
//  ScoreLogic.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 24/10/2015.
//  Copyright © 2015 Alicia Sykes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ScoreLogic{
    
    let um = UserManagement()


    func incrementScore(playerId: Int){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "id == %i", playerId)
        
        do {
            if let results = try appDelegate.managedObjectContext!.executeFetchRequest(request) as? [NSManagedObject] {
                if results.count != 0{
                    let managedObject = results[0]
                    managedObject.setValue(getOldScore(playerId) + 1, forKey: "score")
                    do {
                        try managedContext!.save()
                    }
                    catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
                
            }
            
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    func getOldScore(playerId: Int) -> Int{
        return um.getUser(playerId)[0].valueForKey("score") as! Int
    }

}