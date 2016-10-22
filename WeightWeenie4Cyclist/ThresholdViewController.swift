//
//  ThresholdViewController.swift
//  WeightWeenie4Cyclist
//
//  Created by Randall Clayborn on 9/16/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit

import AVFoundation

class ThresholdViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    let shotShotSound: String = "ShotGun"
    let stopSound: String = "Stop"
    let noodleySound: String = "get-ready-to-move-yr-noodley"
    let restSound: String = "rest"
    let applauseSound: String = "applause"
    
    var startTime = TimeInterval()
    var timer:Timer = Timer()
    
    @IBOutlet weak var StartWhenReadyLABEL: UILabel!
    @IBOutlet weak var StartOutButton: UIButton!
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var TLabel: UILabel!
    
    var setCount = 0
    let seconds = UInt8()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playAudio(String: noodleySound)
    }
    
    @IBAction func start(_ sender: AnyObject) {
        if (!timer.isValid) {
            StartOutButton.isEnabled = true
            inLabel.text = "GO GO GO!!!"
            StartWhenReadyLABEL.isHidden = true
            //voice Comand "Go!"
            playAudio(String: shotShotSound)
            
            let aSelector : Selector = #selector(ThresholdViewController.updateTime)
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
    
    func updateTime() {
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
        
        if minutes >= 3 { // stop timer after 2 minutes.
            setCount += 1
            setLabel.text = "\(setCount)"
            inLabel.text = ""
            
            //Voice comands "REST"
            playAudio(String: restSound)
            
            timer.invalidate()
            prepareRestingTimer()
        }
    }
    
    func prepareRestingTimer() {
        
        if (!timer.isValid) {
            inLabel.text = ""
            let rSelector : Selector = #selector(ThresholdViewController.restingTimer)
            
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: rSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func restingTimer() {
        inLabel.text = "RESTING: Easy Pace, Recover"
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
        
        // stop timer after 2 minutes.
        if minutes >= 2 {
            setLabel.text = "Set: \(setCount)"
            inLabel.text = "Press Start to do another set"
            
            timer.invalidate()
            applauseSoundOne()
        }
    }
    
    func applauseSoundOne() {
        playAudio(String: applauseSound)
    }
    
    func Stop() {
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer = nil
        }
    }
    
    func playAudio(String: String) {
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
        
        let ac = UIAlertController(title: "Improve Threshold!", message: "Ride as hard as you can for 3 minutes then recover at an easy pace for 2 minutes. Do 3 sets.", preferredStyle: .actionSheet)
        
        let popover = ac.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: 32, y: 32, width: 64, height: 84)
        
        present(ac, animated: true, completion: nil)
        
        perform(#selector(ThresholdViewController.dismissPop), with: nil, afterDelay: 4.0)
    }
    
    func dismissPop() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

