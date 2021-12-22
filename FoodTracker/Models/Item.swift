//
//  Item.swift
//  FoodTracker
//
//  Created by Gael G. on 12/12/21.
//

import Foundation
import CoreData

struct Item: Identifiable {
    let id: UUID
    let title: String
    let quantity: Double
    let note: String
    let expirationDate: Date?
    let objectID: NSManagedObjectID?
    
    init(id: UUID = UUID(), title: String, quantity: Double = 1.0, note: String = "", expirationDate: Date? = Date(), objectID: NSManagedObjectID? = nil) {
        self.id = id
        self.title = title
        self.quantity = quantity
        self.note = note
        self.expirationDate = expirationDate
        self.objectID = objectID
    }
    
    /// Gets the amount of days left before an item expires.
    /// - Returns: The amount of days between expiration and today
    func daysUntilExpired() -> Int? {
        if let date = expirationDate {
            let today = Date()
            let components = Calendar.current.dateComponents([.day, .hour], from: today, to: date)
            let daysLeft = components.day!
            if daysLeft > 0 {
                return daysLeft + 1
            } else if daysLeft < 0 {
                return daysLeft
            }
            return (components.hour! > 0 ? 1 : 0)
        }
        return nil
    }
}
