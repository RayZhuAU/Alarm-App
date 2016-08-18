//
//  RealmHelper.swift
//  Alarm App
//
//  Created by Ray Zhu on 15/08/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    static func addAlarm(alarm: Alarm) {
        let realm = try! Realm()
        try! realm.write(){
            realm.add(alarm)
        }
    }
    static func deleteAlarm(alarm: Alarm){
        let realm = try! Realm()
        try! realm.write(){
            realm.delete(alarm)
        }
    }
    static func retrieveAlarms() -> Results<Alarm>{
        let realm = try! Realm()
        let alarm = realm.objects(Alarm).filter("inFolder == false")
        return alarm.sorted("time", ascending: true)
    }
    static func addFolder(folder: Folder) {
        let realm = try! Realm()
        try! realm.write(){
            realm.add(folder)
        }
    }
    static func deleteFolder(folder: Folder){
        let realm = try! Realm()
        try! realm.write(){
            realm.delete(folder)
        }
    }
    static func retrieveFolders() -> Results<Folder>{
        let realm = try! Realm()
        let folder = realm.objects(Folder)
        return folder.sorted("title", ascending: true)
    }
    static func addAlarmToFolder(folder: Folder, alarm: Alarm) {
        let realm = try! Realm()
        try! realm.write() {
            folder.alarms.append(alarm)
        }
    }
    static func removeAlarmFromFolder(folder: Folder, alarm: Alarm) {
        let realm = try! Realm()
        try! realm.write() {
            folder.alarms.delete(alarm)
        }
    }
}