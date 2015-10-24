

import UIKit
import CoreData
import Foundation

class PlayersViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Get system defaults stored data
    //    let defaults = NSUserDefaults.standardUserDefaults()
    
    // UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    
    // Properties
    var players = [NSManagedObject]()
    var savedUsers =  NSArray()
    var nextPlayer = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self;
        
        title = "Players"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        savedUsers = loadUsers()
        
        if savedUsers.count < 2 {
            savePlayer("Player 1", num: 1)
            savePlayer("Player 2", num: 2)
        }
    }
    
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Player",
            message: "Enter Player Name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.savePlayer(textField!.text!, num: 0)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    
    func savePlayer(name: String, num: Int) {
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
        player.setValue(Int(round(Double(NSDate().timeIntervalSince1970.description)!)), forKey: "id")
        
        
        do {
            try managedContext!.save()
            players.append(player)
            savedUsers = loadUsers()
            self.tableView.reloadData()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
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
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return savedUsers.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            let player = savedUsers[indexPath.row]
            cell!.textLabel!.text = player.valueForKey("name") as? String
            cell!.tag = player.valueForKey("id") as! Int
            let image : UIImage = UIImage(named: "defaultpic")!
            cell!.imageView!.image = image
            
            if let playerSelected = player.valueForKey("selected"){
                let truePlayerSelected = playerSelected as! Int
                if(truePlayerSelected != 0){ selectCell(cell!, playerNum: truePlayerSelected) }
                else{ deselectCell(cell!)}
            }
            else{ deselectCell(cell!)}
        return cell!
        
    }

    
    func selectCell(cell: UITableViewCell, playerNum: Int){
        let imageName = playerNum == 1 ? "tick_player1" : "tick_player2"
        let selectedImage: UIImageView = UIImageView(image: UIImage(named: imageName));
        cell.accessoryView = selectedImage;
        cell.imageView?.tag = playerNum
    }
    
    func deselectCell(cell: UITableViewCell){
        let image: UIImageView = UIImageView();
        cell.accessoryView = image;
        cell.imageView?.tag = 0
    }
    
    
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
    
    
    // Function which returns an int for whatever is the next player to make selection
    func getNextPlayerSelection() -> Int{
        if nextPlayer == 1{ nextPlayer = 2; return 2}
        else  {nextPlayer = 1; return 1}
    }
    
    // Function that removes the last seletion from a given plater
    func removeLastSelectionFromPlayer(playerNum: Int){
        for row in 0..<tableView.numberOfRowsInSection(0){
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))
            if(cell?.imageView?.tag == playerNum){
                deselectCell(cell!)
                updateUserAsSelected(cell!.tag, newVal: 0)
            }
        }
    }
    
    
    // When cell is pressed
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        if cell?.imageView!.tag != nextPlayer || cell?.imageView!.tag == 0{
            let currentUserNum = getNextPlayerSelection()   // Which person is pressing cell
            cell?.imageView!.tag = currentUserNum           // Add in an image
            removeLastSelectionFromPlayer(currentUserNum)   // Remove tick from previous cell
            updateUserAsSelected(cell!.tag, newVal: currentUserNum) // Update user record in database
            self.tableView.reloadData()                     // Reload the table
        }
    }

    
    
    
}










