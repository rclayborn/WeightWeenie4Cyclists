//
//  CreditViewController.swift
//  WeightWeenie4Cyclist
//
//  Created by Randall Clayborn on 9/16/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit
import MessageUI

class CreditViewController: UIViewController, MFMailComposeViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func EmaiMeButton(_ sender: AnyObject) {
        //send me an email...
        let email = "claybear39@yahoo.com"
        let url = NSURL(string: "mailto:\(email)")
        // UIApplication.shared.openURL(url as! URL)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as! URL, completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url as! URL)
        }
    }
   
}
