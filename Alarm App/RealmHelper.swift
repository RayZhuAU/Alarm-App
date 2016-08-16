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
        let note = realm.objects(Alarm)
        return note.sorted("time", ascending: true)
    }
}