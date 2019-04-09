//
//  Objects.swift
//  Budgie
//
//  Created by Christopher Fulford on 24/02/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import Foundation

class LocalDay: LocalManaging {
    var cells: [Cell]?
    var date: Date
    var value: Float = 0
    var db: Day?

    init(from date: Date?, data: [Day]?) {
        self.date = date ?? Date()
        self.propogate(using: data)
    }
    
    // MARK: - Public:
    func refresh() {
        let week = self.createLocalWeek(from: Date())
        let day = week?.days?.first(where: {$0.date == self.date})
        self.value = day?.value ?? 0
        self.cells = day?.cells
    }
    
    // MARK: - Private:
    private func propogate(using persistedDays: [Day]?) {
        guard
            let persistedDays = persistedDays?.reversed(),
            let persistedDay = persistedDays.first(where: { persistedDay in
                Calendar.current.isDate(self.date,
                                        inSameDayAs: persistedDay.date! as Date)
            })
        else { return }
        
        self.db = persistedDay
        self.cells = persistedDay.cells?.sortedArray(using:
            [NSSortDescriptor(key: "date", ascending: true)]) as? [Cell]
        self.value = calculateValue(for: persistedDay)
    }
}
