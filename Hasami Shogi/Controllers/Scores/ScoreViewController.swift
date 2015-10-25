

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
        savedUsers = um.loadUsers()
    }
    
    override func viewDidAppear(animated: Bool) {
        savedUsers = um.loadUsers()
        self.tableView.reloadData()
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
            
            let txtScore = UILabel(frame: CGRectMake(0, 0, 200, 21))
            txtScore.center = CGPointMake(160, 284)
            txtScore.textAlignment = NSTextAlignment.Center
            txtScore.text = player.valueForKey("score")?.description
            
            cell?.accessoryType = .DetailButton
            cell!.accessoryView = txtScore
            
//            let image : UIImage = UIImage(named: "defaultpic")!
//            cell!.imageView!.image = image
            return cell!
            
    }
    

    
    
    
}











