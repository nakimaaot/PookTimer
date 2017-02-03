//
//  TabataViewController.swift
//  PookTimer
//
//  Created by Tanpisit Jampa on 2/2/2560 BE.
//  Copyright © 2560 Tanpisit Jampa. All rights reserved.
//

import UIKit
import AVFoundation

class TabataViewController: UIViewController {

    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblRest: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    var btnColor = UIColor(red: 255/255, green: 100/255, blue: 0/255, alpha: 1)
    
    // Normal timer
    var timer: Timer?
    var startStopWatch = true
    
    // Rest timer
    var restTimer: Timer?
    var restStartStopWatch = true

    var countLoop = 0
    var maxLoop = 2
    
    var tmpWorktimeSecs = 0
    var tmpResttimeSecs = 0
    var worktimeSecs = 0
    var resttimeSecs = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnStart.setTitleColor(btnColor, for: .normal)
        btnStart.backgroundColor = UIColor.white
        
        btnReset.setTitleColor(btnColor, for: .normal)
        btnReset.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        maxLoop = defaults.integer(forKey: SettingViewController.roundValueKey)
        
        worktimeSecs = defaults.integer(forKey: SettingViewController.worktimeValueKey)
        resttimeSecs = defaults.integer(forKey: SettingViewController.resttimeValueKey)
        tmpWorktimeSecs = worktimeSecs
        tmpResttimeSecs = resttimeSecs

        let (tmpWorktimeMin, tmpWorktimeSec) = getMinSec(currentSec: worktimeSecs)
        let (tmpResttimeMin, tmpResttimeSec) = getMinSec(currentSec: resttimeSecs)
        lblTimer.text = String(format: "%02d:%02d", tmpWorktimeMin, tmpWorktimeSec)
        lblRest.text = String(format: "%02d:%02d", tmpResttimeMin, tmpResttimeSec)
        updateLblCount()
    }
    
    // MARK: -- Action
    
    @IBAction func tapStart(_ sender: AnyObject) {
        if startStopWatch {
            AudioServicesPlaySystemSound(1070);
            if countLoop == 0 {
                countLoop = 1
            }
            updateLblCount()
            startTimer()
            
            btnStart.setTitleColor(UIColor.white, for: .normal)
            btnStart.backgroundColor = btnColor
        } else {
            stopTimer()
            stopRestTimer()
            
            btnStart.setTitleColor(btnColor, for: .normal)
            btnStart.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func tapReset(_ sender: AnyObject) {
        countLoop = 0
        resetTimer()
        resetRestTimer()
        updateLblCount()
        
        btnStart.setTitleColor(btnColor, for: .normal)
        btnStart.backgroundColor = UIColor.white
    }
    
    // MARK: -- Logic normal timer
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TabataViewController.updateStopwatch), userInfo: nil, repeats: true)
        startStopWatch = false
        
        btnStart.setTitle("Stop", for: .normal)
        lblTimer.textColor = btnColor
    }
    
    func stopTimer() {
        timer?.invalidate()
        startStopWatch = true
        
        btnStart.setTitle("Start", for: .normal)
        lblTimer.textColor = UIColor.black
    }
    
    func resetTimer() {
        stopTimer()
        timer = nil
        
        let (tmpWorktimeMin, tmpWorktimeSec) = getMinSec(currentSec: worktimeSecs)
        let (tmpResttimeMin, tmpResttimeSec) = getMinSec(currentSec: resttimeSecs)
        lblTimer.text = String(format: "%02d:%02d", tmpWorktimeMin, tmpWorktimeSec)
        lblRest.text = String(format: "%02d:%02d", tmpResttimeMin, tmpResttimeSec)
    }

    func updateStopwatch() {
        tmpWorktimeSecs -= 1
        
        if tmpWorktimeSecs <= 0 {
            countLoop += 1
            
            tmpWorktimeSecs = worktimeSecs
            
            if maxLoop < countLoop {
                countLoop = 0
                resetTimer()
                btnStart.setTitleColor(btnColor, for: .normal)
                btnStart.backgroundColor = UIColor.white
            } else {
                resetTimer()
                // startTimer()
                AudioServicesPlaySystemSound(1009);
                startRestTimer()
            }
        }
        
        let (min, sec) = getMinSec(currentSec: tmpWorktimeSecs)
        lblTimer.text = String(format: "%02d:%02d", min, sec)
    }
    
    // MARK: -- Logic rest timer
    
    func startRestTimer() {
        restTimer?.invalidate()
        restTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TabataViewController.updateRestStopwatch), userInfo: nil, repeats: true)
        
        btnStart.setTitle("Stop", for: .normal)
        lblRest.textColor = btnColor
    }
    
    func stopRestTimer() {
        restTimer?.invalidate()
        lblRest.textColor = UIColor.black
    }
    
    func resetRestTimer() {
        stopRestTimer()
        restTimer = nil
    }
    
    func updateRestStopwatch() {
        tmpResttimeSecs -= 1
        
        if tmpResttimeSecs <= 0 {
            
            tmpResttimeSecs = resttimeSecs
            
            if maxLoop < countLoop {
                resetRestTimer()
            } else {
                resetRestTimer()
                startTimer()
            }
            updateLblCount()
        }
        
        let (min, sec) = getMinSec(currentSec: tmpResttimeSecs)
        lblRest.text = String(format: "%02d:%02d", min, sec)
    }
    
    // MARK: -- Util
    
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
    
    func updateLblCount() {
        lblCount.text = "\(countLoop) / \(maxLoop)"
    }

}
