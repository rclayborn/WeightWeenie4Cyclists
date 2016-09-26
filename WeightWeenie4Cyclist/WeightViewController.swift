//
//  WeightViewController.swift
//  WeightWeenie4Cyclist
//
//  Created by Randall Clayborn on 9/16/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit

class WeightViewController: UIViewController {

    @IBOutlet weak var segmentedControlMF: UISegmentedControl!
    
    @IBOutlet weak var FeetInput: UITextField!
    @IBOutlet weak var inchInput: UITextField!
    @IBOutlet weak var poundsTextField: UITextField!
    
    @IBOutlet weak var InchLabel: UILabel!
    @IBOutlet weak var cmLabel: UILabel!
    
    @IBOutlet weak var leanLabel: UILabel!
    @IBOutlet weak var idealBodyFat: UILabel!
    @IBOutlet weak var targetWeightLabel: UILabel!
    @IBOutlet weak var bodyFatLabel: UILabel!
    @IBOutlet weak var finalTargetWeightLabel: UILabel!
    
    @IBOutlet weak var BMILabel: UILabel!
    @IBOutlet weak var PoundsToLoseLabel: UILabel!
    
    var largeFrame = false
    var smallFrame = false
    var mediumFrame = false
    var male = true
    
    //-----------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        InchLabel.text = ""
        cmLabel.text = ""
        male = true
    }
    //need to intragate this method
    @IBAction func segmentedControlMFAction(_ sender: AnyObject) {
        
        if(segmentedControlMF.selectedSegmentIndex == 0)
        {
            print("Male")
            //one more pound per inch
            male = true
        }
        else if(segmentedControlMF.selectedSegmentIndex == 1)
        {
            print("Female")
            //one less pound per inch
            male = false
            //do math for female
        }
    }
    //-------------------------------------------
    @IBAction func SmallWrist(_ sender: AnyObject) {
        smallFrame = true
        print("You have a Small Frame")
        //Subtract 10% off your target weight
    }
    
    @IBAction func mediumWrist(_ sender: AnyObject) {
        mediumFrame = true
        print("You have a Medium Frame")
        //keep your target weight. do nothing.
    }
    
    @IBAction func largeWrist(_ sender: AnyObject) {
        largeFrame = true
        print("You have a Large Frame")
        //add 10% to your target weight
    }
    
    @IBAction func CalculateButton(_ sender: AnyObject) {
        self.hideKeyboardWhenTappedAround()
        
        let firstInteger = Float(FeetInput.text!)
        let secondInteger = Float(inchInput.text!)
        let thirdInteger = Float(poundsTextField.text!)
        
        if firstInteger == 5.0 {
            let fiveFoot = Float(106)
            
            //figuring base line weight(no fat)
            let baseWeight = (fiveFoot + (secondInteger! * 6))
            idealBodyFat.text = "Base line Weight(no fat) \(baseWeight)"
            
            //total inches for feet and inches given
            let totalInches = (firstInteger! * 12) + secondInteger!
            InchLabel.text = "Height-Inches: \(totalInches)"
            
            //putting inches into Cm
            let totalCm = totalInches * 2.55
            //putting cm in a label
            cmLabel.text = "Height-Cm: \(totalCm)"
            
            //add option for user input HERE?
            let math1 = baseWeight * 704.7
            let math2 = totalInches * totalInches
            let BMI = math1 / math2
            //formatt number so it is not that long.
            let str = NSString(format: "%.1f", BMI)
            BMILabel.text = "BMI: \(str)"
            
            //figure total pounds of fat
            let poundsOfFat = thirdInteger! * BMI / 100
            
            let POF = NSString(format: "%.1f", poundsOfFat)
            bodyFatLabel.text = "Total Pounds of fat: \(POF)"
            
            let leanBodyMass = Double(thirdInteger! - poundsOfFat)
            leanLabel.text = "Your lean Body Mass: \(Int(leanBodyMass))"
            
            //ideal body fat is 18% later let user choice a range of % (0-30)
            let bodyFatMath  = 1.00 - 0.18
            
            let finalWeight = Double(leanBodyMass) / Double(bodyFatMath)
            
            // final female weight
            let femaleWeight = finalWeight / 10
            let addFemaleWeight = finalWeight + femaleWeight
            
            // let strFinal = NSString(format: "%.0f", (finalWeight))
            finalTargetWeightLabel.text = "Your Best cycling Weight: \(Int(finalWeight))"
            
            //pounds to lose
            let poundsToLose = Int(thirdInteger!) - Int(finalWeight)
            PoundsToLoseLabel.text = "pound needed to lose: \(poundsToLose)"
            
            //must intergrate this method
            if largeFrame == true {
                if male == true {
                    let strFinalL = NSString(format: "%.0f", finalWeight)
                    targetWeightLabel.text = "Target Weight: \(strFinalL)"
                }
                if male == false {
                    let strFinalL = NSString(format: "%.0f", addFemaleWeight)
                    targetWeightLabel.text = "Target Weight: \(strFinalL)"
                }
            }
            if mediumFrame == true {
                if male == true {
                    let strFinalM = NSString(format: "%.0f", finalWeight)
                    targetWeightLabel.text = "Target Weight: \(strFinalM)"
                }
                if  male == false {
                    //female
                    let strFinalM = NSString(format: "%.0f", addFemaleWeight)
                    targetWeightLabel.text = "Target Weight: \(strFinalM)"
                }
            }
            if smallFrame == true {
                if male == true {
                   let strFinalS = NSString(format: "%.0f", finalWeight)
                    targetWeightLabel.text = "Target Weight: \( strFinalS)"
                }
                if male == false {
                    //female
                    let strFinalS = NSString(format: "%.0f",  addFemaleWeight)
                    targetWeightLabel.text = "Target Weight:\(strFinalS)"
                }
            }
        }
    }
    
    @IBAction func resetAllButton(_ sender: AnyObject) {
        leanLabel.text = ""
        idealBodyFat.text = ""
        targetWeightLabel.text = ""
        bodyFatLabel.text = ""
        finalTargetWeightLabel.text = ""
        BMILabel.text = ""
        PoundsToLoseLabel.text = ""

        FeetInput.text! = ""
        inchInput.text! = ""
        poundsTextField.text! = ""
        
        viewDidLoad()
        if(segmentedControlMF.selectedSegmentIndex == 0)
        {
            print("Male")
            //one more pound per inch
            male = true
        }
        else if(segmentedControlMF.selectedSegmentIndex == 1)
        {
            print("Female")
            //one less pound per inch
            male = false
            //do math for female
        }
    }
    
}
//end of Class beginning of extension.
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

   
}
