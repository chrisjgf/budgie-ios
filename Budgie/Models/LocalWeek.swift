//
//  LocalWeek.swift
//  Budgie
//
//  Created by Chris on 25/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import Foundation

class LocalWeek: DataManaging {
    private(set) var date: Date
    private(set) var days: [LocalDay]?
    private(set) var value: Float = 0
    
    init(date: Date, data: [Day]?) {
        self.date = date
        self.days = propogateDays(using: data)
    }
    
    // MARK: - Private:
    private func propogateDays(using persistedDays: [Day]?) -> [LocalDay] {
        var days = [LocalDay]()
        for i in (0..<7) {
            let date = Calendar.current.date(byAdding: .day,
                                             value: i,
                                             to: self.date)
            let day = LocalDay(from: date, data: persistedDays)
            days.append(day)
        }
        return days
    }
}
