//
//  AlarmScheduler.swift
//  Alarm App
//
//  Created by Ray Zhu on 16/08/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import Foundation
import UIKit

class AlarmScheduler {
    
    static func scheduleNotification(alarm: Alarm) {
        let notification = UILocalNotification()
        notification.category = "ALARM_CATEGORY"
        notification.alertBody = "\(alarm.title)"
        notification.soundName = UILocalNotificationDefaultSoundName
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let newDate = cal.startOfDayForDate(date)
        let currentTime = 0 - newDate.timeIntervalSinceNow
        if (currentTime - alarm.fullTime) > 0 {
            notification.fireDate = NSDate(timeIntervalSinceNow: 86400 - (currentTime - alarm.fullTime))
            print("alarm set in \(86400 - (currentTime - alarm.fullTime)) seconds")
        }
        else {
            notification.fireDate = NSDate(timeIntervalSinceNow: alarm.fullTime - currentTime)
            print("alarm set in \(alarm.fullTime - currentTime)")
        }
        notification.userInfo = ["UUID": alarm.fullTime]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        return
    }
    
    static func cancelNotification(alarm: Alarm) {
        var ID: NSTimeInterval
        ID = alarm.fullTime
        for event in UIApplication.sharedApplication().scheduledLocalNotifications! {
            let notification = event as UILocalNotification
            if (notification.userInfo!["UUID"] as! NSTimeInterval == ID) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                print("alarm cancelled")
                break
            }
        }
    }
}