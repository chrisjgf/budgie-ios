//
//  SettingsCellTitle.swift
//  Budgie
//
//  Created by Chris on 05/05/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit

class SettingsCellToggle: UITableViewCell {
    
    static let identifier = "cellSettingsToggle"
    static let nib = UINib(nibName: "SettingsCellToggle", bundle: nil)
    
    @IBOutlet weak var title: UILabel!
    
}
