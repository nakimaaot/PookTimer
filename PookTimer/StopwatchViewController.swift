//
//  StopWatchViewController.swift
//  PookTimer
//
//  Created by Tanpisit Jampa on 2/3/2560 BE.
//  Copyright © 2560 Tanpisit Jampa. All rights reserved.
//

import UIKit
import AVFoundation

class StopwatchViewController: UIViewController {

    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    var btnColor = UIColor(red: 255/255, green: 100/255, blue: 0/255, alpha: 1)
    var timer: Timer?
    var startStopWatch = true
    
    var timeSecs = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        btnStart.setTitleColor(btnColor, for: .normal)
        btnStart.backgroundColor = UIColor.white
        
        btnReset.setTitleColor(btnColor, for: .normal)
        btnReset.backgroundColor = UIColor.white
    }
    
    // MARK: -- Action
    
    @IBAction func tapStartStop(_ sender: AnyObject) {
        if startStopWatch {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    @IBAction func tapReset(_ sender: AnyObject) {
        stopTimer()
        timer = nil
        timeSecs = 0
        lblTimer.text = "00:00"
        
        btnStart.setTitleColor(btnColor, for: .normal)
        btnStart.backgroundColor = UIColor.white
    }
    
    // MARK: -- Logic
    
    func startTimer() {
        AudioServicesPlaySystemSound(1070);
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(StopwatchViewController.updateStopwatch), userInfo: nil, repeats: true)
        startStopWatch = false
        
        btnStart.setTitle("Stop", for: .normal)
        lblTimer.textColor = btnColor
        
        btnStart.setTitleColor(UIColor.white, for: .normal)
        btnStart.backgroundColor = btnColor

    }
    
    func stopTimer() {
        timer?.invalidate()
        startStopWatch = true
        
        btnStart.setTitle("Start", for: .normal)
        lblTimer.textColor = UIColor.black
        
        btnStart.setTitleColor(btnColor, for: .normal)
        btnStart.backgroundColor = UIColor.white
    }

    func updateStopwatch() {
        timeSecs += 1
        
        let (min, sec) = getMinSec(currentSec: timeSecs)
        lblTimer.text = String(format: "%02d:%02d", min, sec)
    }
    
    func getMinSec(currentSec: Int) -> (Int, Int) {
        var min = 0
        var sec = 0
        if currentSec >= 60 {
            min = Int(currentSec / 60)
            sec = Int(currentSec % 60)
        } else {
            sec = currentSec
        }
        return (min: min, sec: sec)
    }

}
