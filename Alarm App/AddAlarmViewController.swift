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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timePicker = ESTimePicker.init(delegate: self)
        // Delegate is optional
        timePicker.frame = CGRectMake(0, 0, self.view.layer.frame.width/2, self.view.layer.frame.height)
        timePicker.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/4)
        self.alarmPickerView!.addSubview(timePicker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        guard hoursLabel.text?.isEmpty == false else {
            return
        }
        guard minutesLabel.text?.isEmpty == false else {
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
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let intHours = Int(newAlarm.hour)
        let intMinutes = Int(newAlarm.minute)
        newAlarm.fullTime = NSTimeInterval((intHours! * 60 * 60) + (intMinutes! * 60))
        RealmHelper.addAlarm(newAlarm)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
