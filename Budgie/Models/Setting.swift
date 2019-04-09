//
//  Setting.swift
//  Budgie
//
//  Created by Chris on 25/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import Foundation

struct Setting {
    let title: String
    let rowTitles: [String]
    
    init(title: String, rowTitles: [String]) {
        self.title = title
        self.rowTitles = rowTitles
    }
}
