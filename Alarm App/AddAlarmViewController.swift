//
//  AddAlarmViewController.swift
//  Alarm App
//
//  Created by Ray Zhu on 15/08/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import UIKit
import ESTimePicker

class AddAlarmViewController: UIViewController, ESTimePickerDelegate {
    
    @IBOutlet weak var alarmTitleTextField: UITextField!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var alarmPickerView: UIView!
    var hours = ""
    var minutes = ""
    var fromVC = ""
    var fromFolder = Folder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timePicker = ESTimePicker.init(delegate: self)
        // Delegate is optional
        timePicker.frame = CGRectMake(0, 0, self.view.layer.frame.width/2, self.view.layer.frame.height)
        timePicker.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/4)
        self.alarmPickerView!.addSubview(timePicker)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func timePickerHoursChanged(timePicker: ESTimePicker!, toHours hours: Int32) {
        self.hours = String(hours)
        hoursLabel.text = "\(hours)"
    }
    func timePickerMinutesChanged(timePicker: ESTimePicker!, toMinutes minutes: Int32) {
        if minutes < 10 {
            minutesLabel.text = "0\(minutes)"
        }
        else {
            minutesLabel.text = "\(minutes)"
        }
        self.minutes = minutesLabel.text!
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        if fromVC == "folder" {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        guard self.hours != "" else {
            return
        }
        guard self.minutes != "" else {
            return
        }
        let newAlarm = Alarm()
        newAlarm.hour = self.hours
        newAlarm.minute = self.minutes
        if self.alarmTitleTextField.text == "" {
            newAlarm.title = "Alarm"
        }
        else {
            newAlarm.title = self.alarmTitleTextField.text!
        }
        newAlarm.image = "alarm"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let intHours = Int(newAlarm.hour)
        let intMinutes = Int(newAlarm.minute)
        newAlarm.fullTime = NSTimeInterval((intHours! * 60 * 60) + (intMinutes! * 60))
        if fromVC == "folder" {
            newAlarm.inFolder = true
            RealmHelper.addAlarmToFolder(fromFolder, alarm: newAlarm)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            newAlarm.inFolder = false
            RealmHelper.addAlarm(newAlarm)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
