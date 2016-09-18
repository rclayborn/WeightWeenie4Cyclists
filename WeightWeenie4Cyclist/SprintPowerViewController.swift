//
//  SprintPowerViewController.swift
//  WeightWeenie4Cyclist
//
//  Created by Randall Clayborn on 9/16/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit

class SprintPowerViewController: UIViewController, CountdownTimerDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    var timer: CountdownTimer!
    
    @IBOutlet weak var TypeSeg: UISegmentedControl!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var SetLabel: UILabel!
    
    var isRunning = true
    var intervalMin = 1
    var intervalSec = 20
    var restMin = 1
    var restSec = 10
    
    var set = 6
    var repeatSet = 6
    
    var typeOFIntervalLabel = ""
    
    @IBOutlet weak var typeOfIntervalLabel: UILabel!
    
    override func viewDidLoad() {
    
    typeOfIntervalLabel.text = "Power, Sprinting"
    isRunning = true
    SetLabel.text = "Set: \(set)"
    
    }
    //--------------start factory method-----------------
    
    func setTime() {
    print("setTime")
    isRunning = true
    // Timer will start at 00:40
    timer = CountdownTimer(timerLabel: timeLabel, startingMin: intervalMin, startingSec: intervalSec)
    timer.delegate = self
    timer.start()
    }
    
    func restTime() {
    print("restTime")
    restLabel.textColor = UIColor.black
    restLabel.text = "REST"
    
    isRunning = false
    timer = CountdownTimer(timerLabel: timeLabel, startingMin: restMin, startingSec: restSec)
    timer.delegate = self
    timer.start()
    }
    
    func countdownEnded() -> Void {
    // Handle countdown finishing
    print("Count Down Ended")
    timer.reset()
    if isRunning == true {
    restTime()
    set += set
    SetLabel.text = "Set: \(set)"
    } else {
    setTime()
    }
    
    if set == repeatSet {
    finishInterval()
    }
    }
    
    func finishInterval() {
    restLabel.textColor = UIColor.red
    restLabel.text = "Finished!"
    timer.reset()
    }
    
    //-----------------ended Factory method------------
    
    @IBAction func startButtonPressed(_ sender: AnyObject) {
    // timer.start() //Begins countdown
    restLabel.textColor = UIColor.green
    restLabel.text = "GO, GO, GO!"
    setTime()
    //make button disappear. then reapear when finiahed.
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
    restLabel.textColor = UIColor.red
    restLabel.text = "Interval Aborted!"
    timer.pause() //Pauses countdown and resets to the initial time
    }
    
    @IBAction func resetButtonPressed(_ sender: AnyObject) {
    timer.reset() //Pauses countdown and resets to the initial time
    }
    
    //--------------------Type of interval------------------------
    
    //            let intervalMin = 0
    //            let intervalSec = 20
    
    //            let restMin = 0
    //            let restSec = 10
    
    //            let setMin = 6
    //            let setSec = 0
    //
    //            let setRestMin = 0
    //            let setRestSec = 0
    
    //            let repeatSet = 6
  
}
