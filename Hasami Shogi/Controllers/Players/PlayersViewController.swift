

import UIKit
import CoreData

class PlayersViewController:  UIViewController, UITableViewDataSource {
    
    // Get system defaults stored data
//    let defaults = NSUserDefaults.standardUserDefaults()
    
    // UI Elements
    @IBOutlet weak var tableView: UITableView!

    
    // Properties
    var players = [NSManagedObject]()
    var savedUsers =  NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return (results)
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
//            
//            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
//            
//            let player = savedUsers[indexPath.row]
//
//            cell!.textLabel!.text = player.valueForKey("name") as? String
//            cell!.imageView!.image = UIImage(named: "defaultpic")
//            return cell!
            

            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            let player = savedUsers[indexPath.row]
            cell!.textLabel!.text = player.valueForKey("name") as? String
            let image : UIImage = UIImage(named: "defaultpic")!
            print("The loaded image: \(image)")
            cell!.imageView!.image = image
            
            return cell!
            
    }
}