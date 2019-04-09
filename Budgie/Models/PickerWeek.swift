//
//  GeneratePastWeeks.swift
//  Budgie
//
//  Created by Christopher Fulford on 30/12/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit

struct PickerWeek {
    let start: Date
    let end: Date
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
    
    // MARK: - Static:
    static func generateWeeks() -> [PickerWeek] {
        var weeks = [PickerWeek]()
        for i in (-12...52).reversed() {
            let previousWeek = Calendar.current.date(byAdding: .weekOfYear, value: -i, to: Date())!
            let endDate = Calendar.current.date(byAdding: .day, value: 6, to: previousWeek.beginning)!
            weeks.append(PickerWeek(start: previousWeek.beginning, end: endDate))
        }
        return weeks
    }
}
