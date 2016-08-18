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
    var folders: Results<Folder>! {
        didSet{
            folderCount = folders.count
            alarmTableView.reloadData()
        }
    }
    var folderCount = 0
    var alarmCount = 0
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    var selectedFolder = 0
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarms = RealmHelper.retrieveAlarms()
        folders = RealmHelper.retrieveFolders()
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        self.alarmTableView.tableFooterView = UIView(frame: CGRectZero)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        self.alarmTableView.addSubview(self.refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.folderCount = folders.count
        self.alarmCount = alarms.count
        self.folderCount = folders.count
        self.alarmTableView.reloadData()
    }
    @IBAction func addAlarmButtonPressed(sender: UIButton) {
    }
    
    @IBAction func addFolderButtonPressed(sender: UIButton) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier != "showFolder" else {
            let folderVC = segue.destinationViewController as! FolderViewController
            folderVC.folder = folders[selectedFolder]
            return
        }
        let popupSegue: CCMPopupSegue = (segue as! CCMPopupSegue)
        if self.view.bounds.size.height < 420 {
            popupSegue.destinationBounds = CGRectMake(0, 0, (UIScreen.mainScreen().bounds.size.height - 20) * 0.75, UIScreen.mainScreen().bounds.size.height - 20)
        }
        else {
            switch segue.identifier! {
            case "newAlarmSegue":
                popupSegue.destinationBounds = CGRectMake(0, 0, self.view.layer.frame.width, self.view.layer.frame.height)
                let addALarmVC = segue.destinationViewController as! AddAlarmViewController
                addALarmVC.fromVC = "view"
            case "newFolderSegue":
                popupSegue.destinationBounds = CGRectMake(0, 0, 300, 300)
            default:
                break
            }
        }
        popupSegue.backgroundBlurRadius = 0
        popupSegue.backgroundViewAlpha = 0.3
        popupSegue.backgroundViewColor = UIColor.blackColor()
        popupSegue.dismissableByTouchingBackground = true
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(alarms.count) + \(folderCount)")
        return alarms.count + folderCount
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlarmTableViewCell", forIndexPath: indexPath) as! AlarmTableViewCell
        if folderCount > 0 {
            let folder = folders[indexPath.row]
            cell.alarmTitleLabel.text = folder.title
            cell.activatedSwitch.hidden = true
            cell.colonLabel.hidden = true
            cell.alarmImageView?.image = UIImage(named: folder.image)
            cell.hoursLabel.hidden = true
            cell.minutesLabel.hidden = true
            cell.folderSwitch.hidden = false
            cell.folderSwitch.tag = indexPath.row
            cell.folderSwitch.addTarget(self, action: #selector(self.folderSwitchChanged(_:)), forControlEvents: .ValueChanged)
            cell.accessoryType = .DisclosureIndicator
            folderCount -= 1
        }
        else {
            print("index path is \(indexPath.row)")
            print("number of folders \(folders.count)")
            let alarm = alarms[indexPath.row - folders.count]
            cell.alarmTitleLabel.text = alarm.title
            cell.hoursLabel.text = alarm.hour
            cell.minutesLabel.text = alarm.minute
            cell.activatedSwitch.hidden = false
            cell.colonLabel.hidden = false
            cell.hoursLabel.hidden = false
            cell.minutesLabel.hidden = false
            cell.folderSwitch.hidden = true
            cell.alarmImageView.image = UIImage(named: alarm.image)
            cell.activatedSwitch.tag = indexPath.row - folders.count
            cell.activatedSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), forControlEvents: .ValueChanged)
            cell.accessoryType = .None
            AlarmScheduler.scheduleNotification(alarm)
        }
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if folders.count < 0 {
                AlarmScheduler.cancelNotification(alarms[indexPath.row])
                RealmHelper.deleteAlarm(alarms[indexPath.row])
                alarms = RealmHelper.retrieveAlarms()
                alarmCount = alarms.count
                folderCount = folders.count
                self.alarmTableView.reloadData()
            }
            else {
                if indexPath.row > folders.count - 1 {
                    AlarmScheduler.cancelNotification(alarms[indexPath.row - folders.count])
                    RealmHelper.deleteAlarm(alarms[indexPath.row - folders.count])
                    alarms = RealmHelper.retrieveAlarms()
                    alarmCount = alarms.count
                    folderCount = folders.count
                    self.alarmTableView.reloadData()
                }
                else {
                    AlarmScheduler.cancelFolderNotification(folders[indexPath.row])
                    RealmHelper.deleteFolder(folders[indexPath.row])
                    folders = RealmHelper.retrieveFolders()
                    folderCount = folders.count
                    self.alarmTableView.reloadData()
                }
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected row \(indexPath.row)")
        if indexPath.row < folders.count {
            self.selectedFolder = indexPath.row
            performSegueWithIdentifier("showFolder", sender: self)
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
    @IBAction func folderSwitchChanged(sender: UISwitch) {
        if sender.on == true {
            AlarmScheduler.scheduleFolderNotification(folders[sender.tag])
        }
        else {
            AlarmScheduler.cancelFolderNotification(folders[sender.tag])
        }
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        folderCount = folders.count
        self.alarmTableView.reloadData()
        refreshControl.endRefreshing()
    }
}
