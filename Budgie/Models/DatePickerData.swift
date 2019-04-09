//
//  DatePickerData.swift
//  Budgie
//
//  Created by Christopher Fulford on 30/12/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit

class PickerData: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // class definition goes here
    var pickerDataSource = PickerWeek.generateWeeks()
    var current: Date!
    var lastSelected: Int?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        let title = "\(pickerDataSource[row].start.asDayMonth) - \(pickerDataSource[row].end.asDayMonthYear)"
        let attributedString = NSMutableAttributedString(string: title)
        pickerLabel.textAlignment = .center
        attributedString.addAttributes([
            .kern: 1.25,
            .font: UIFont.systemFont(ofSize: 14)],
            range: NSRange(location: 0, length: title.count))
        pickerLabel.attributedText = attributedString
        
        if row > 52 {
            pickerLabel.textColor = UIColor.gray
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 52 {
            NotificationCenter.default.post(name: .DatePickerInvalid, object: nil)
        } else {
            current = pickerDataSource[row].start
            NotificationCenter.default.post(name: .DatePickerCompletion, object: nil)
        }
        
        let info: [String:Int] = [
            "row": row
        ]
        NotificationCenter.default.post(name: .DatePickerLast, object: nil, userInfo: info)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }

}
