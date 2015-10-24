

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self;
        
        title = "Players"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        savedUsers = loadUsers()
    }
    
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Player",
            message: "Enter Player Name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.saveName(textField!.text!)
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
    
    
    func saveName(name: String) {
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
        player.setValue(0, forKey: "selected")
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
                if(playerSelected as! Int != 0){ selectCell(cell!) }
                else{ deselectCell(cell!)}
            }
            else{ deselectCell(cell!)}
        return cell!
        
    }

    
    func selectCell(cell: UITableViewCell){
        print(cell.tag)
        let imageName = "tick";
        let selectedImage: UIImageView = UIImageView(image: UIImage(named: imageName));
        cell.accessoryView = selectedImage;
    }
    
    func deselectCell(cell: UITableViewCell){
        let image: UIImageView = UIImageView();
        cell.accessoryView = image;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)

        updateUserAsSelected(cell!.tag)
        self.tableView.reloadData()
    }
    
    
    func updateUserAsSelected(id: Int) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "User")
//        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            if let results = try appDelegate.managedObjectContext!.executeFetchRequest(request) as? [NSManagedObject] {
                if results.count != 0{
                    let managedObject = results[0]
                    managedObject.setValue(1, forKey: "selected")
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










