//
//  HowViewController.swift
//  WeightWeenie4Cyclist
//
//  Created by Randall Clayborn on 9/16/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit
import MessageUI

class HowViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
print("How to use this app")
        // Do any additional setup after loading the view.
    }

    @IBAction func EmailButton(_ sender: AnyObject) {
    //send me email
        let email = "claybear39@yahoo.com"
        let url = NSURL(string: "mailto:\(email)")
        // UIApplication.shared.openURL(url as! URL)
        UIApplication.shared.open(url as! URL, completionHandler: nil)
        
    }
  
}
