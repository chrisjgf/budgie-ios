//
//  CSVModel.swift
//  Budgie
//
//  Created by Chris on 25/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import Foundation

struct CSVItem {
    var date: Date
    var title: String?
    var value: Float
    
    init(date: Date, title: String?, value: Float){
        self.date = date
        self.title = title
        self.value = value
    }
}
