//
//  PSTimer.swift
//  DIYInterval
//
//  Created by Randall Clayborn on 9/13/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import Foundation
import UIKit


protocol CountdownTimerDelegate {
    func countdownEnded() -> Void
}

class CountdownTimer {
    
    let timerLabel: UILabel
    var timing: Bool = false
    var startingMin: Int
    var startingSec: Int
    var secLeft: Int
    var minLeft: Int
    var endTime: Int!
    var timer: Timer!
    var delegate: CountdownTimerDelegate!
    
    init(timerLabel: UILabel, startingMin: Int, startingSec: Int) {
        self.timerLabel = timerLabel
        self.startingMin = startingMin
        self.startingSec = startingSec
        self.minLeft = startingMin
        self.secLeft = startingSec
        
        refreshTimerLabel()
    }
    
    func refreshTimerLabel() {
        let secString = secLeft < 10 ? "0\(secLeft)" : "\(secLeft)"
        timerLabel.text = "\(minLeft):\(secString)"
    }
    
    func start() {
        if (!timing) {
            timing = true
            if minLeft == startingMin {
                if secLeft == 0 {
                    minLeft = startingMin - 1
                    secLeft = 59
                } else {
                    secLeft -= secLeft
                }
                
                refreshTimerLabel()
            }
            
            endTime = Int(round(NSDate().timeIntervalSince1970)) + minLeft*60 + secLeft
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountdownTimer.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    func pause() {
        timing = false
        timer.invalidate()
    }
    
    func reset() {
        pause()
        minLeft = startingMin
        secLeft = startingSec
        refreshTimerLabel()
    }
    
    // MARK: - Timer Logic
    dynamic func updateTimer() {
        let timeDiff = endTime - Int(round(NSDate().timeIntervalSince1970))
        minLeft = timeDiff / 60
        secLeft = timeDiff % 60
        if minLeft <= 0 && secLeft <= 0 {
            
            reset()
            delegate.countdownEnded()
            
            return
        }
        refreshTimerLabel()
    }
}
