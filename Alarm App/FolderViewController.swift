//
//  FolderViewController.swift
//  Alarm App
//
//  Created by Ray Zhu on 18/08/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController {
    
    var folder = Folder()

    @IBOutlet weak var alarmTableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FolderViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "\(folder.title)"
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.alarmTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAlarmPressed(sender: UIButton) {
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addAlarmToFolder" {
            let addAlarmVC = segue.destinationViewController as! AddAlarmViewController
            addAlarmVC.fromVC = "folder"
            addAlarmVC.fromFolder = self.folder
        }
    }
}
extension FolderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.alarms.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! FolderAlarmTableViewCell
        let alarm = folder.alarms[indexPath.row]
        cell.alarmTitleLabel.text = alarm.title
        cell.alarmHoursLabel.text = alarm.hour
        cell.alarmMinutesLabel.text = alarm.minute
        cell.alarmImageView.image = UIImage(named: alarm.image)
        cell.activatedSwitch.tag = indexPath.row
        cell.activatedSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), forControlEvents: .ValueChanged)
        AlarmScheduler.scheduleNotification(alarm)
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            AlarmScheduler.cancelNotification(folder.alarms[indexPath.row])
            RealmHelper.deleteAlarm(folder.alarms[indexPath.row])
            self.alarmTableView.reloadData()
        }
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on == true {
            AlarmScheduler.scheduleNotification(folder.alarms[sender.tag])
        }
        else {
            AlarmScheduler.cancelNotification(folder.alarms[sender.tag])
        }
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.alarmTableView.reloadData()
        refreshControl.endRefreshing()
    }
}