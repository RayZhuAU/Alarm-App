//
//  Folder.swift
//  Alarm App
//
//  Created by Ray Zhu on 17/08/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import Foundation
import RealmSwift
class Folder: Object {

    dynamic var title = ""
    dynamic var activated = false
    dynamic var image = ""
    var alarms = List<Alarm>()
    
}
