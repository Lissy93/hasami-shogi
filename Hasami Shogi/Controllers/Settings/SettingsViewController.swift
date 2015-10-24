

import UIKit

class SettingsViewController: UITableViewController {
    
    // Get system defaults stored data
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // UI Elements
    @IBOutlet weak var numStartingPiecesSlider: UISegmentedControl!
    @IBOutlet weak var piecesRemainingToWinLabel: UILabel!
    @IBOutlet weak var piecesToWinStepper: UIStepper!
    @IBOutlet weak var winFiveInRowSwitch: UISwitch!
    @IBOutlet weak var enableSoundSwitch: UISwitch!
    
    // Default settings values (for first time use)
    let defaultNumStartingPieces = 9
    let defaultPiecesRemainingToWin = 1
    let defaultWinFiveInRow = false
    let defaultEnableSound = true
    
    // The number of starting pieces value
    var numOfStartingPieces: Int = 9 {
        willSet(newValue){
            defaults.setObject(newValue, forKey: "numOfStartingPieces")
            self.numStartingPiecesSlider.selectedSegmentIndex = (newValue==18) ? 1 : 0
        }
    }
    
    // The number of pieces remainnig to win value
    var numPiecesRemainingToWin: Int = 1{
        willSet(newValue) {
            defaults.setObject(newValue, forKey: "numPiecesRemainingToWin")
            self.piecesRemainingToWinLabel.text = String(newValue)
            self.piecesToWinStepper.value = Double(newValue)
        }
    }

    
    // Win with 5 in a row
    var fiveInARowToWin: Bool = false{
        willSet(newValue) {
            defaults.setObject(newValue, forKey: "fiveInARowToWin")
        }
    }
    
    
    // Enable Sound
    var enableSound: Bool = true{
        willSet(newValue) {
            defaults.setObject(newValue, forKey: "enableSound")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialiseValues()
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
//        self.piecesRemainingToWinLabel.text = Int(sender.value).description
    }
    
    
    // Win with 5 pieces in a row switch was changed
    @IBAction func fiveInARowChanged(sender: UISwitch) {
        fiveInARowToWin = sender.on
    }
    
    
    // Sound on or off switch was changed
    @IBAction func enableSoundChanged(sender: UISwitch) {
        enableSound = sender.on
    }
    
    
    // If the number of starting pieces is 18 then change limit of pieces to win
    func changeLimitOfPiecesToWin(){
        piecesToWinStepper.maximumValue = (numOfStartingPieces == 9) ? 8 : 17
        if(numOfStartingPieces == 9 && numPiecesRemainingToWin > 8){
            numPiecesRemainingToWin = Int(round(Double(numPiecesRemainingToWin/2))) 
        }
        if(self.piecesRemainingToWinLabel.text == "0"){
            if(numPiecesRemainingToWin == 0){numPiecesRemainingToWin = defaultPiecesRemainingToWin}
            self.piecesRemainingToWinLabel.text = String(numPiecesRemainingToWin)
        }
    }
    
    
    func initialiseValues(){
        //Get the number of starting pieces and set
        if let numStartingPiecesDefault: Int = defaults.integerForKey("numOfStartingPieces") {
            numOfStartingPieces = numStartingPiecesDefault
        }
        else{numOfStartingPieces = defaultNumStartingPieces }
        
        // Get the numberPiecesRemainingValue and set
        if let numPiecesRemainingToWinDefault: Int = defaults.integerForKey("numPiecesRemainingToWin") {
            numPiecesRemainingToWin = numPiecesRemainingToWinDefault
        }
        else{numPiecesRemainingToWin = defaultPiecesRemainingToWin }
        
        changeLimitOfPiecesToWin()
        
        // Get and set Enable win with 5 in a row
        if defaults.boolForKey("fiveInARowToWin") {
            fiveInARowToWin = defaults.boolForKey("fiveInARowToWin")
        }
        else{fiveInARowToWin = defaultWinFiveInRow}
        self.winFiveInRowSwitch.setOn(fiveInARowToWin, animated: true)
        
        
        // Get and set Enable Sound
        if defaults.boolForKey("enableSound") {
            enableSound = defaults.boolForKey("enableSound")
        }
        else{enableSound = defaultEnableSound }
        self.enableSoundSwitch.setOn(enableSound, animated: true)
    }
    
    
}