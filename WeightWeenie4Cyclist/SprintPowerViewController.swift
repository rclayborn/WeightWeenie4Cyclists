//
//  SprintPowerViewController.swift
//  WeightWeenie4Cyclist
//
//  Created by Randall Clayborn on 9/16/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit

import AVFoundation

class SprintPowerViewController: UIViewController {
    
    @objc var audioPlayer: AVAudioPlayer!
    @objc let shotShotSound: String = "ShotGun"
    @objc let stopSound: String = "Stop"
    @objc let noodleySound: String = "get-ready-to-move-yr-noodley"
    @objc let restSound: String = "rest"
    @objc let applauseSound: String = "applause"
    @objc let goSound: String = "go"
    
    @objc var startTime = TimeInterval()
    @objc var timer:Timer = Timer()
    
    @IBOutlet weak var StartWhenReadyLABEL: UILabel!
    @IBOutlet weak var StartOutButton: UIButton!
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var TLabel: UILabel!
    
    @objc var setCount = 0
    @objc let seconds = UInt8()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         playAudio(String: noodleySound)
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func start(_ sender: AnyObject) {
        if (!timer.isValid) {
            StartOutButton.isEnabled = true
            inLabel.text = "GO GO GO!!!"
            StartWhenReadyLABEL.isHidden = true
            //voice Comand "Go!"
            playAudio(String: shotShotSound)
            
            let aSelector : Selector = #selector(SprintPowerViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        timer.invalidate()
        playAudio(String: stopSound)
        setCount = 0
        inLabel.text = "STOP"
        setLabel.text = "\(setCount)"
        TLabel.text = "00:00"
        StartWhenReadyLABEL.isHidden = false
    }
    
    @objc func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        TLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
        if seconds >= 20 { // stop timer after 10 seconds.
            setCount += 1
            setLabel.text = "\(setCount)"
            inLabel.text = ""
            
            //Voice comands "REST"
            playAudio(String: restSound)
            
            timer.invalidate()
            prepareRestingTimer()
        }
    }
    
    @objc func prepareRestingTimer() {
        
        if (!timer.isValid) {
            inLabel.text = ""
            let rSelector : Selector = #selector(SprintPowerViewController.restingTimer)
            
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: rSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    @objc func restingTimer() {
        inLabel.text = "RESTING: Coast"
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        TLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
        // stop timer after 10 seconds.
        if seconds >= 10 {
            setLabel.text = "Set: \(setCount)"
            inLabel.text = "Press Start to do another set"
            
            timer.invalidate()
            applauseSoundOne()
        }
    }
    
    @objc func applauseSoundOne() {
        playAudio(String: applauseSound)
    }
    
    @objc func Stop() {
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer = nil
        }
    }
    
    @objc func playAudio(String: String) {
        do {
            if let bundle = Bundle.main.path(forResource: (String), ofType: "wav") {
                let alertSound = NSURL(fileURLWithPath: bundle)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                try audioPlayer = AVAudioPlayer(contentsOf: alertSound as URL)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func instructionButton(_ sender: AnyObject) {
        timer.invalidate()
        StartWhenReadyLABEL.isHidden = false
        playAudio(String: stopSound)
        inLabel.text = "STOP"
        TLabel.text = "00:00"
        
        let ac = UIAlertController(title: "Power Builder!", message: "While moving, Sprint for 20 Second as hard as possible. Then, coast for 10 seconds. Do 6-8 sets", preferredStyle: .actionSheet)
        
        let popover = ac.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: 32, y: 32, width: 64, height: 84)
        
        present(ac, animated: true, completion: nil)
        
        perform(#selector(SprintPowerViewController.dismissPop), with: nil, afterDelay: 4.0)
    }
    
    @objc func dismissPop() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

