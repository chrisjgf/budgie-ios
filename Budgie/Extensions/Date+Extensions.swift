//
//  Date+Extensions.swift
//  Budgie
//
//  Created by Chris on 25/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import Foundation

extension Date {
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale.current
        return formatter.string(from: self).capitalized
    }
    
    var asLocaleMedium: String{
        let formatter = DateFormatter()
        // formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    var asDayMonthYear: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        return formatter.string(from: self)
    }
    
    var asDayMonth: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: self)
    }
    
    var asDayDateMonth: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd MMM"
        return formatter.string(from: self)
    }
    
    var asSingleValue: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    var returnWeekRange: String{
        let start: Date! = self
        let end: Date! = Calendar.current.date(byAdding: .day, value: 6, to: start)
        
        let str = start.asDayMonth + " - " + end.asDayMonth
        return str
    }
    
    var beginning: Date {
        let cal = Calendar(identifier: .gregorian)
        let dateComponent = cal.dateComponents([.weekday , .month , .day], from: self)
        let defaultWeekday = UserDefaults.standard.integer(forKey: "WeekdaySettings")
        
        var day = dateComponent.weekday! - ((defaultWeekday != 0) ? (defaultWeekday) : 1)
        let inversedDay = ((day < 0) ? (day * -1) : day)
        day = (inversedDay == 7) ? 0 : inversedDay
        
        let start = cal.date(byAdding: .day, value: -day, to: self)!
        return cal.startOfDay(for: start)
    }

}
