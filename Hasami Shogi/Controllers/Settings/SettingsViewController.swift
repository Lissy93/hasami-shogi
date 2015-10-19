

import UIKit

class SettingsViewController: UITableViewController {
    
    
    @IBOutlet weak var piecesRemainingToWinLabel: UILabel!
    @IBOutlet weak var piecesToWinStepper: UIStepper!
    
    var numOfStartingPieces = 9
    
    var numPiecesRemainingToWin: Int = 1{
        willSet(newValue) {
            self.piecesRemainingToWinLabel.text = String(newValue)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // How many pieces to start with slider was changed
    @IBAction func startingPiecesChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // Nine is selected
            numOfStartingPieces = 9
        case 1: // Eighteen is selected
            numOfStartingPieces = 18
        default:
            break; 
        }
        changeLimitOfPiecesToWin() // Update limits on stepper
    }
    
    
    // How many pieces remaining to win button was chamged
    @IBAction func piecesRemainingToWinChanged(sender: UIStepper) {
        numPiecesRemainingToWin = Int(Int(sender.value).description)!
        self.piecesRemainingToWinLabel.text = Int(sender.value).description
    }
    
    
    // Win with 5 pieces in a row switch was changed
    @IBAction func fiveInARowChanged(sender: UISwitch) {
        
    }
    
    
    // Sound on or off switch was changed
    @IBAction func enableSoundChanged(sender: UISwitch) {
        
    }
    
    
    // If the number of starting pieces is 18 then change limit of pieces to win
    func changeLimitOfPiecesToWin(){
        piecesToWinStepper.maximumValue = (numOfStartingPieces == 9) ? 8 : 17
        if(numOfStartingPieces == 9 && numPiecesRemainingToWin > 8){
            numPiecesRemainingToWin = 8
        }
    }
    
}