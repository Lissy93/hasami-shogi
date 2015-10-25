

import UIKit
import CoreData
import Foundation

class PlayersViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    
    // Properties
    var players = [NSManagedObject]()
    var savedUsers =  NSArray()
    var nextPlayer = 1
    
    
    // User Management Operations
    let um = UserManagement()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self;
        
        title = "Players"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        savedUsers = um.loadUsers()
        
        if savedUsers.count < 2 {
            um.savePlayer("Player 1", num: 1)
            um.savePlayer("Player 2", num: 2)
        }
    }
    
    
    // When add new user button is pressed
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Player",
            message: "Enter Player Name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
    
                self.players.append(self.um.savePlayer(textField!.text!, num: 0))
                self.savedUsers = self.um.loadUsers()
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

    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return savedUsers.count
    }
    
    
    // Generates a cell for each user and adds to tableview
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            let player = savedUsers[indexPath.row]
            cell!.textLabel!.text = player.valueForKey("name") as? String
            cell!.tag = player.valueForKey("id") as! Int
            let image : UIImage = UIImage(named: "defaultpic")!
            cell!.imageView!.image = image
            
            cell?.textLabel!.font = UIFont (name: "HelveticaNeue-UltraLight", size: 20)
            
            if let playerSelected = player.valueForKey("selected"){
                let truePlayerSelected = playerSelected as! Int
                if(truePlayerSelected != 0){ selectCell(cell!,
                    playerNum: truePlayerSelected) }
                else{ deselectCell(cell!)}
            }
            else{ deselectCell(cell!)}
        return cell!
        
    }

    
    // Marks a user as selected on the UI
    func selectCell(cell: UITableViewCell, playerNum: Int){
        let imageName = playerNum == 1 ? "tick_player1" : "tick_player2"
        let selectedImage: UIImageView =
            UIImageView(image: UIImage(named: imageName));
        cell.accessoryView = selectedImage;
        cell.imageView?.tag = playerNum
    }
    
    
    // Unmarks the user as selected on the UI
    func deselectCell(cell: UITableViewCell){
        let image: UIImageView = UIImageView();
        cell.accessoryView = image;
        cell.imageView?.tag = 0
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
                um.updateUserAsSelected(cell!.tag, newVal: 0)
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
            um.updateUserAsSelected(cell!.tag, newVal: currentUserNum) // Update user record in database
            self.tableView.reloadData()                     // Reload the table
        }
    }

    
    
    
}










