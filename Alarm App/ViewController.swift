//
//  ViewController.swift
//  Alarm App
//
//  Created by Ray Zhu on 24/06/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import UIKit
import CCMPopup
import RealmSwift

class ViewController: UIViewController {
    
    var alarms: Results<Alarm>!{
        didSet{
            alarmTableView.reloadData()
        }
    }
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        alarms = RealmHelper.retrieveAlarms()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.alarmTableView.reloadData()
    }
    @IBAction func addAlarmButtonPressed(sender: UIButton) {
        self.alarmTableView.reloadData()
    }
    
    @IBAction func addFolderButtonPressed(sender: UIButton) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let popupSegue: CCMPopupSegue = (segue as! CCMPopupSegue)
        if self.view.bounds.size.height < 420 {
            popupSegue.destinationBounds = CGRectMake(0, 0, (UIScreen.mainScreen().bounds.size.height - 20) * 0.75, UIScreen.mainScreen().bounds.size.height - 20)
        }
        else {
            popupSegue.destinationBounds = CGRectMake(0, 0, self.view.layer.frame.width, self.view.layer.frame.height)
        }
        popupSegue.backgroundBlurRadius = 0
        popupSegue.backgroundViewAlpha = 0.3
        popupSegue.backgroundViewColor = UIColor.blackColor()
        popupSegue.dismissableByTouchingBackground = true
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlarmTableViewCell", forIndexPath: indexPath) as! AlarmTableViewCell
        let alarm = alarms[indexPath.row]
        cell.alarmTitleLabel.text = alarm.title
        cell.hoursLabel.text = alarm.hour
        cell.minutesLabel.text = alarm.minute
        cell.activatedSwitch.tag = indexPath.row
        cell.activatedSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), forControlEvents: .ValueChanged)
        AlarmScheduler.scheduleNotification(alarm)
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            RealmHelper.deleteAlarm(alarms[indexPath.row])
            alarms = RealmHelper.retrieveAlarms()
        }
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on == true {
            AlarmScheduler.scheduleNotification(alarms[sender.tag])
        }
        else {
            AlarmScheduler.cancelNotification(alarms[sender.tag])
        }
    }
}
