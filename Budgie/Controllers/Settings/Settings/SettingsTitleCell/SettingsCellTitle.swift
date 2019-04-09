//
//  SettingsCellTitle.swift
//  Budgie
//
//  Created by Chris on 05/05/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit

class SettingsCellTitle: UITableViewCell {
    
    static let identifier = "cellSettingsTitle"
    static let nib = UINib(nibName: "SettingsCellTitle", bundle: nil)
    
    // MARK: - @IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Intitialisers
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var index: Int? {
        didSet {
            let defaultWeekday = UserDefaults.standard.integer(forKey: "WeekdaySettings")
            self.accessoryType = index == defaultWeekday ? .checkmark : .none
        }
    }
    
    // MARK: - Life cycle:
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // FIXME: - iPhone Plus font size
        if DeviceType.isiPhone6P {
            if #available(iOS 8.2, *) {
                titleLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.light)
            } else {
                // Fallback on earlier versions
            }
        }
        // Initialization code
    }
    
}
