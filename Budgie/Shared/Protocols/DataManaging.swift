//
//  DataBridge.swift
//  Budgie
//
//  Created by Chris on 06/05/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit
import CoreData

enum Entity: String {
    case day, cell, image
}

protocol DataManaging {
    func createExpense(for date: Date?) -> Cell?
    func deleteManagedObject(_ obj: NSManagedObject?)
    func fetchManagedObjects(for entity: Entity) -> [NSManagedObject]?
}

extension DataManaging {
    
    // MARK: - Public:
    func createExpense(for date: Date?) -> Cell? {
        guard let date = date else { return nil }
        let cellEntity = NSEntityDescription.entity(forEntityName: "Cell",
                                                    in: CoreDataStack.shared.databaseContext)
        let cell = NSManagedObject(entity: cellEntity!,
                                   insertInto: CoreDataStack.shared.databaseContext) as? Cell
        if let day = self.fetchDay(for: date) {
            cell?.day = day
        } else {
            let day = self.createNewDay(for: date)
            cell?.day = day
        }
        cell?.date = date
        return cell
    }
    
    func deleteManagedObject(_ obj: NSManagedObject?) {
        guard let obj = obj else { return }
        CoreDataStack.shared.databaseContext.delete(obj)
        CoreDataStack.shared.saveContext()
    }
    
    func fetchManagedObjects(for entity: Entity) -> [NSManagedObject]? {
        let entityName = String(describing: entity).capitalized
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sectionSortDescriptor]
        
        var results : [NSManagedObject]?
        do {
            results = try CoreDataStack.shared.databaseContext.fetch(request) as? [NSManagedObject]
            return results
        } catch let error as NSError {
            print("No days stored: \(error.debugDescription)")
            return nil
        }
    }
    
    // MARK: - Private:
    private func fetchDay(for date: Date) -> Day? {
        guard let days = fetchManagedObjects(for: .day) as? [Day] else{
            return nil
        }
        return days.first(where: { $0.date! as Date == date }) ?? nil
    }
    
    private func createNewDay(for date: Date?) -> Day? {
        guard let date = date else { return nil }
        let dayEntity = NSEntityDescription.entity(forEntityName: "Day",
                                                   in: CoreDataStack.shared.databaseContext)
        let day = NSManagedObject(entity: dayEntity!,
                                  insertInto: CoreDataStack.shared.databaseContext) as? Day
        day?.date = date
        return day
    }
}
