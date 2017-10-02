//
//  PowerViewController.swift
//  WeightWeenie4Cyclist
//
//  Created by Randall Clayborn on 9/16/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit

class PowerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var weightTextfield: UITextField!
    @IBOutlet weak var wattsTextfield: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    
    @IBOutlet weak var powerZoneLabel: UILabel!
    @IBOutlet weak var powerZoneLabel2: UILabel!
    @IBOutlet weak var powerZoneLabel3: UILabel!
    @IBOutlet weak var powerZoneLabel4: UILabel!
    @IBOutlet weak var powerZoneLabel5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weightTextfield.delegate = self
        self.wattsTextfield.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        wattsTextfield.resignFirstResponder()
        weightTextfield.resignFirstResponder()
        return true
    }
    
    @IBAction func calculate(_ sender: AnyObject) {
        
        let weightInteger = Int(weightTextfield.text!)
        let wattsInteger = Int(wattsTextfield.text!)
        
        let kmWeight = Double(weightInteger!) / 2.2
        let FTP = Double(wattsInteger!) / kmWeight
        
        let srtFTP = NSString(format: "%.2f", FTP)
        answerLabel.text = "Your Power To Weight Ratio: \(srtFTP)"
        
        //fix
        switch FTP {
        case 0...2.5:
            print("beginner")
            LevelLabel.text = "Beginner, cat 5 racer"
        case 2.6...3:
            LevelLabel.text = "Fair, cat 4 racer"
        case 3.1...3.5:
            LevelLabel.text = "Moderate, cat 3 racer"
        case   3.6...4.2:
            LevelLabel.text = "Good, Local Hotdog, cat 2 racer"
        case   4.3...4.7:
            LevelLabel.text = "Very Good,  Semi or Pro Racer"
        default:
            LevelLabel.text = "Pro Racer"
        }
        
        let zone1 = (FTP * 55.0) + FTP
        let zone2 = (FTP * 74.0) + FTP
        let zone3 = (FTP * 89.0) + FTP
        let zone4 = (FTP * 104.0) + FTP
        let zone5 = (FTP * 120.0) + FTP
        
        let strZone1 = NSString(format: "%.2f", zone1)
        let strZone2 = NSString(format: "%.2f", zone2)
        let strZone3 = NSString(format: "%.2f", zone3)
        let strZone4 = NSString(format: "%.2f", zone4)
        let strZone5 = NSString(format: "%.2f", zone5)
        
        powerZoneLabel.text = "Zone 1: \(0.0)-\(strZone1)"
        powerZoneLabel2.text = "Zone 2: \(strZone1) - \(strZone2)"
        powerZoneLabel3.text = "Zone 3: \(strZone2) - \(strZone3)"
        powerZoneLabel4.text = "Zone 4: \(strZone3) - \(strZone4)"
        powerZoneLabel5.text = "Zone 5: \(strZone4) - \(strZone5)"
        
        weightTextfield.resignFirstResponder()
        wattsTextfield.resignFirstResponder()

    }
   
}
