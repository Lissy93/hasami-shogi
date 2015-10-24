//
//  UserManagement.swift
//  Hasami Shogi
//
//  Created by Alicia Sykes on 24/10/2015.
//  Copyright © 2015 Alicia Sykes. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UserManagement{

    init(){
        if loadUsers().count < 2 {
            savePlayer("Player 1", num: 1, uniqueId: 1)
            savePlayer("Player 2", num: 2, uniqueId: 2)
        }
    }
    
    
    // Get a current Players from Users List
    func getPlayers(playerNum: PlayerNum) -> Player{
        let rawNum = playerNum == .player1 ? 1 : 2
        var playerObject = Player(playerNum: playerNum, playerName: "Player \(rawNum)", id: 0, playerTurn: true)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "selected == %i", rawNum)
        do {
            let results: NSArray = try (managedContext?.executeFetchRequest(request))!
            playerObject.playerName = results[0].valueForKey("name") as! String
            playerObject.id = results[0].valueForKey("id") as! Int
        }
        catch let error as NSError { print(error) }
        return playerObject
    }

    // Saved a specified player into the database
    func savePlayer(name: String, num: Int, uniqueId: Int) -> NSManagedObject {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("User",
            inManagedObjectContext:managedContext!)
        
        let player = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        
        player.setValue(name, forKey: "name")
        player.setValue("", forKey: "picture")
        player.setValue(0, forKey: "score")
        player.setValue(num, forKey: "selected")
        player.setValue(uniqueId, forKey: "id")
        
        
        do {
            try managedContext!.save()
            loadUsers()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        return player
    }
    
    // Saves a specified player into the database
    func savePlayer(name: String, num: Int) -> NSManagedObject {
        let time: Int = Int(round(Double(NSDate().timeIntervalSince1970.description)!))
        return savePlayer(name, num: num, uniqueId: time)
    }
    
    
    // Loads all users from the database
    func loadUsers() -> NSArray{
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do {
            let results: NSArray = try (managedContext?.executeFetchRequest(request))!
            return results
        }
        catch let error as NSError {
            print(error)
        }
        
        return NSArray()
    }
    
    
    // Updates a specific user
    func updateUserAsSelected(id: Int, newVal: Int) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            if let results = try appDelegate.managedObjectContext!.executeFetchRequest(request) as? [NSManagedObject] {
                if results.count != 0{
                    let managedObject = results[0]
                    managedObject.setValue(newVal, forKey: "selected")
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
    
    

}