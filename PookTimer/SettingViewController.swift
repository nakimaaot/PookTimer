//
//  SettingViewController.swift
//  PookTimer
//
//  Created by Tanpisit Jampa on 2/3/2560 BE.
//  Copyright © 2560 Tanpisit Jampa. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SettingViewController: UITableViewController {

    @IBOutlet weak var btnWorktime: UIButton!
    @IBOutlet weak var btnResttime: UIButton!
    @IBOutlet weak var btnRound: UIButton!
    
    static let roundValueKey = "roundValue"
    static let worktimeValueKey = "worktimeValue"
    static let resttimeValueKey = "resttimeValue"

    let roundIndexKey = "roundIndex"
    let worktimeMinIndexKey = "worktimeMinIndex"
    let worktimeSecIndexKey = "worktimeSecIndex"
    let resttimeMinIndexKey = "resttimeMinIndex"
    let resttimeSecIndexKey = "resttimeSecIndex"
    
    var timeMins:[String] = []
    var timeSecs:[String] = []
    var rounds:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        updateUI()
    }
    
    private func initData() {
        for index in 0...50 {
            timeMins += ["\(index)m"]
        }

        for index in 0...59 {
            timeSecs += ["\(index)s"]
        }
        
        for index in 1...50 {
            rounds += ["\(index)"]
        }
    }
    
    private func updateUI() {
        btnWorktime.setTitle("\(timeMins[getIndex(key: worktimeMinIndexKey)]) : \(timeSecs[getIndex(key: worktimeSecIndexKey)])", for: .normal)
        btnResttime.setTitle("\(timeMins[getIndex(key: resttimeMinIndexKey)]) : \(timeSecs[getIndex(key: resttimeSecIndexKey)])", for: .normal)
        btnRound.setTitle(rounds[getIndex(key: roundIndexKey)], for: .normal)
    }
    
    private func settingData() {
        let defaults = UserDefaults.standard
        
        let worktime = getIndex(key: worktimeMinIndexKey) * 60 + getIndex(key: worktimeSecIndexKey)
        let resttime = getIndex(key: resttimeMinIndexKey) * 60 + getIndex(key: resttimeSecIndexKey)
        let round = Int(rounds[getIndex(key: roundIndexKey)])!
        
        defaults.set(worktime, forKey: SettingViewController.worktimeValueKey)
        defaults.set(resttime, forKey: SettingViewController.resttimeValueKey)
        defaults.set(round, forKey: SettingViewController.roundValueKey)
    }
    
    @IBAction func chooseWorktime(_ sender: AnyObject) {
        ActionSheetMultipleStringPicker.show(withTitle: "Work time", rows: [
            timeMins,
            timeSecs
            ], initialSelection: [getIndex(key: worktimeMinIndexKey), timeSecs[getIndex(key: worktimeSecIndexKey)]], doneBlock: {
                picker, indexes, values in
                
                self.saveIndex(value: Int("\(indexes![0])")!, key: self.worktimeMinIndexKey)
                self.saveIndex(value: Int("\(indexes![1])")!, key: self.worktimeSecIndexKey)
                self.updateUI()
                self.settingData()
                return
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }

    @IBAction func chooseResttime(_ sender: AnyObject) {
        ActionSheetMultipleStringPicker.show(withTitle: "Rest time", rows: [
            timeMins,
            timeSecs
            ], initialSelection: [getIndex(key: resttimeMinIndexKey), timeSecs[getIndex(key: resttimeSecIndexKey)]], doneBlock: {
                picker, indexes, values in
                
                self.saveIndex(value: Int("\(indexes![0])")!, key: self.resttimeMinIndexKey)
                self.saveIndex(value: Int("\(indexes![1])")!, key: self.resttimeSecIndexKey)
                self.updateUI()
                self.settingData()
                return
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func chooseRound(_ sender: AnyObject) {
        ActionSheetMultipleStringPicker.show(withTitle: "Round", rows: [
            rounds
            ], initialSelection: [getIndex(key: roundIndexKey)], doneBlock: {
                picker, indexes, values in
                
                self.saveIndex(value: Int("\(indexes![0])")!, key: self.roundIndexKey)
                self.updateUI()
                self.settingData()
                return
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    private func saveIndex(value: Int, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    private func getIndex(key: String) -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: key)
    }
}
