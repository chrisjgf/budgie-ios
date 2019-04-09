//
//  LocalManaging.swift
//  Budgie
//
//  Created by Chris on 07/04/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import Foundation

protocol LocalManaging: DataManaging {
    func createLocalWeek(from date: Date) -> LocalWeek?
    func calculateValue(for day: Day?) -> Float
}

extension LocalManaging {
    func createLocalWeek(from date: Date) -> LocalWeek? {
        guard let daysInDB = self.fetchManagedObjects(for: .day) as? [Day] else {
            return nil
        }
        return LocalWeek(date: date.beginning, data: daysInDB)
    }
    func calculateValue(for day: Day?) -> Float {
        guard let day = day else { return 0.0 }
        var totalValue: Float = 0
        day.cells?.forEach({totalValue += ($0 as? Cell)?.value ?? 0})
        return totalValue
    }
}
