//
//  SettingsTableHeader.swift
//  Budgie
//
//  Created by Chris on 05/05/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit

class SettingsTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = "SettingsTableHeader"
    static let nib = UINib(nibName: "SettingsTableHeader", bundle: nil)
    
    @IBOutlet weak var title: UILabel!

}
