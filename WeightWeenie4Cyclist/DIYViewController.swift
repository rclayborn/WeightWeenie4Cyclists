//
//  DIYViewController.swift
//  WeightWeenie4Cyclist
//
//  Created by Randall Clayborn on 10/21/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit
import AVFoundation

class DIYViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startButtonOutlet: UIButton!
    @objc var audioPlayer: AVAudioPlayer!
    @objc let shotShotSound: String = "ShotGun"
    @objc let countSound: String = "countdown"
    @objc let stopSound: String = "Stop"
    @objc let noodleySound: String = "get-ready-to-move-yr-noodley"
    @objc let restSound: String = "rest"
    @objc let applauseSound: String = "applause"
    
    @IBOutlet weak var specialInfoLabel: UILabel!
    
    @IBOutlet weak var intMinuteTextfield: UITextField!
    @IBOutlet weak var intSecondTextfield: UITextField!
    @IBOutlet weak var restSecondTextfield: UITextField!
    @IBOutlet weak var restMinuteTextfield: UITextField!
    @IBOutlet weak var setInputTextfield: UITextField!
    
    @IBOutlet weak var NumberOfSetsLabel: UILabel!
    @IBOutlet weak var GoNameFinishedLabel: UILabel!
    @objc var dayTime = true
    @objc var startTime = TimeInterval()
    @objc var timer:Timer = Timer()
    @IBOutlet weak var timerLabel: UILabel!
    
    @objc var numberOfSets = 0
    @objc let strMinutes = String()
    @objc let strSeconds = String()
    @objc let strFraction = String()
    @objc let minutes = UInt8()
    @objc let seconds = UInt8()
    
    // var setsInput = 0
    @objc var intervalMinute = 0
    @objc var intervalSecond = 0
    @objc var restMinute = 0
    @objc var restSecond = 0
    @objc var UserMaxSets = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intMinuteTextfield.delegate = self
        intSecondTextfield.delegate = self
        restSecondTextfield.delegate = self
        restMinuteTextfield.delegate = self
        setInputTextfield.delegate = self
        
        GoNameFinishedLabel.isHidden = true
        specialInfoLabel.text = "Fill in Times then press start"
        playAudio(String: noodleySound)
        self.hideKeyboardWhenTappedAround()
    }
    //============setting up textfields=====================
    //with a delegate this function will not let user type more then 2 numbers in textfield.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 2
    }
    
    //setting up textfield after they were checked in StartButtonPressed.
    @objc func settingUpTextField() {
        intervalMinute = Int(intMinuteTextfield.text!)!
        intervalSecond = Int(intSecondTextfield.text!)!
        restSecond = Int(restSecondTextfield.text!)!
        restMinute = Int(restMinuteTextfield.text!)!
        UserMaxSets = Int(setInputTextfield.text!)!
        numberOfSets = 1
        
        //checking to see if number is larger then 60 in any textfield.
        if intervalSecond >= 60 ||  intervalMinute >= 60 || restSecond >= 60 || restMinute >= 60 || UserMaxSets >= 60 {
            //print("number too big!")
            specialInfoLabel.textColor = UIColor.red
            specialInfoLabel.text = "no numbers larger then 60!"
            
        } else {
            //play sound
            playAudio(String: countSound)
            //start timer
            let countSelector : Selector = #selector(ReadyToStart)
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: countSelector, userInfo: nil, repeats: false)
            // self.ReadyToStart()
        }
    }
    
    //starts timer and repeats until invalidate called.
    @IBAction func startButtonPressed(_ sender: AnyObject) {
        timer.invalidate()
        //checking to see if any of the textfields are empty before continuing.
        startButtonOutlet.isHidden = true
        if (intMinuteTextfield.text?.isEmpty)! || (intSecondTextfield.text?.isEmpty)! || (restMinuteTextfield.text?.isEmpty)! || (restSecondTextfield.text?.isEmpty)! || (setInputTextfield.text?.isEmpty)!  {
            // print("Please fill in interval time: mintues and seconds")
            specialInfoLabel.text = "Fill in ALL Times above!"
            
        }else {
            settingUpTextField()
        }
    }
    
    //=============Starting INterval Point=====================
    @objc func ReadyToStart() {
        timer.invalidate()
        playAudio(String: shotShotSound)
        numberOfSets = 0
        //print("START Timers")
        
        NumberOfSetsLabel.text = "Number Of Set: 0"
        NumberOfSetsLabel.textColor = UIColor.black
        
        timerLabel.textColor = UIColor.black
        
        GoNameFinishedLabel.isHidden = false
        GoNameFinishedLabel.textColor = UIColor.green
        GoNameFinishedLabel.text = "GO!"
        //start timer....
        if (!timer.isValid) {
            let aSelector : Selector = #selector(updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
        }
    }
    
    //The button to stop timer and reset labels.
    @IBAction func stopTimerButton(_ sender: AnyObject) {
        playAudio(String: stopSound)
        GoNameFinishedLabel.textColor = UIColor.red
        GoNameFinishedLabel.text = "Canceled"
        specialInfoLabel.textColor = UIColor.red
        specialInfoLabel.text = "You will have to start all over"
        timerLabel.text = "00:00:00"
        NumberOfSetsLabel.text = "0"
        numberOfSets = 0
        timer.invalidate()
        startButtonOutlet.isHidden = false
    }
    
    //restart after first run through from createSet function.
    @objc func reStartIntervalTimer() {
        playAudio(String: shotShotSound)
        timerLabel.textColor = UIColor.black
        GoNameFinishedLabel.isHidden = false
        GoNameFinishedLabel.textColor = UIColor.green
        GoNameFinishedLabel.text = "GO!"
        NumberOfSetsLabel.textColor = UIColor.black
        
        if (!timer.isValid) {
            let aSelector : Selector = #selector(updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
        }
    }
    
    //the interval time machine.
    @objc func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
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
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
        //stop inteval time, resets timelabel and send to rest functions.
        if Int(minutes) >= intervalMinute && Int(seconds) >= intervalSecond {
            timerLabel.text = "00:00:00"
            restTime()
        }
    }
    //stops interval timer and reset labels.
    @objc func restTime() {
        timer.invalidate()
        playAudio(String: restSound)
        GoNameFinishedLabel.text = "Rest!"
        GoNameFinishedLabel.textColor = UIColor.red
        timerLabel.textColor = UIColor.lightGray
        
        StartRestClock()
    }
    
    //rest time machine
    @objc func updateRestTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
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
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
        //stop rest timer at unsers settings and send to set function.
        if Int(minutes) >= restMinute && Int(seconds) >= restSecond {
            timer.invalidate()
            playAudio(String: restSound)
            timerLabel.text = "00:00:00"
            createSet()
            // print("rest is over")
        }
    }
    
    //starts REST timer.
    @objc func StartRestClock() {
        timer.invalidate()
        if (!timer.isValid) {
            let aSelector : Selector = #selector(updateRestTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
        }
    }
    
    //This function counts down intervals so user know set number.
    @objc func createSet() {
        
        //keeps repeating until all sets are done.
        if numberOfSets <= UserMaxSets {
            numberOfSets += 1
            NumberOfSetsLabel.text = "Number of Intervals: \(numberOfSets)"
            
            //switches set colors of label to be more noticable.
            switch numberOfSets {
            case 1:
                NumberOfSetsLabel.textColor = UIColor.orange
            case 2:
                NumberOfSetsLabel.textColor = UIColor.blue
            case 3:
                NumberOfSetsLabel.textColor = UIColor.yellow
            case 4:
                NumberOfSetsLabel.textColor = UIColor.green
            case 5:
                NumberOfSetsLabel.textColor = UIColor.cyan
            case 6:
                NumberOfSetsLabel.textColor = UIColor.brown
            case 6...99:
                NumberOfSetsLabel.textColor = UIColor.black
            default:
                NumberOfSetsLabel.textColor = UIColor.black
            }
            specialInfoLabel.text = "Do another interval!"
            GoNameFinishedLabel.textColor = UIColor.green
            GoNameFinishedLabel.text = "GO!"
            timerLabel.textColor = UIColor.black
            reStartIntervalTimer()
            
        }
        //ends at user max time input then, give message to user then, Stops timer.
        if numberOfSets >= UserMaxSets {
            playAudio(String: applauseSound)
            NumberOfSetsLabel.text = "Number of Intervals: \(numberOfSets)"
            specialInfoLabel.textColor = UIColor.red
            specialInfoLabel.text = "Congratulations!"
            GoNameFinishedLabel.text = "Finished!"
            GoNameFinishedLabel.textColor = UIColor.black
            timer.invalidate()
            startButtonOutlet.isHidden = false
        }
    }
    //============Sound functions=======================
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
    
}


