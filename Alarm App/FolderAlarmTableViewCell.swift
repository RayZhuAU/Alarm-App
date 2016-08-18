//
//  FolderAlarmTableViewCell.swift
//  Alarm App
//
//  Created by Ray Zhu on 18/08/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import UIKit

class FolderAlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var activatedSwitch: UISwitch!
    @IBOutlet weak var alarmTitleLabel: UILabel!
    @IBOutlet weak var alarmImageView: UIImageView!
    @IBOutlet weak var alarmHoursLabel: UILabel!
    @IBOutlet weak var alarmMinutesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
