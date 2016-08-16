//
//  Alarm.swift
//  Alarm App
//
//  Created by Ray Zhu on 15/08/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import Foundation
import RealmSwift

class Alarm: Object {
    
    dynamic var title = ""
    dynamic var hour = ""
    dynamic var minute = ""
    dynamic var time = ""
    dynamic var activated = false
    dynamic var fullTime = NSTimeInterval()

}