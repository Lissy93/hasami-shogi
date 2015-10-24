

import UIKit
import CoreData
import Foundation

class ScoresViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    
    // Properties
    var players = [NSManagedObject]()
    var savedUsers =  NSArray()
    
    
    // User Management Operations
    let um = UserManagement()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self;
        
        title = "High Scores"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

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

            return cell!
            
    }
    

    
    
    
}











