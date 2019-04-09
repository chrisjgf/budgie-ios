//
//  ExportCSV.swift
//  Budgie
//
//  Created by Chris on 10/06/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import Foundation
import UIKit

protocol Exportable {
    func createCSV(for dataArr: [CSVItem], header: String) -> URL?
}

extension Exportable where Self: UIViewController {
    func createCSV(for dataArr: [CSVItem], header: String) -> URL? {
        var csvText = header
        let fileName = "Expenses.csv"
        let path = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        
        for data in dataArr {
            let date = data.date.asDayDateMonth
            let value: String = "\(data.value)"
            let title = (data.title != "") ? data.title! : "—"
            csvText.append("\(date),\(title),\(value)\n")
        }
        
        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("Failed to create file")
            print("\(error)")
            return nil
        }
    }
}
