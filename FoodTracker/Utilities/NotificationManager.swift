//
//  NotificationManager.swift
//  FoodTracker
//
//  Created by Gael G. on 12/17/21.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager {
    @AppStorage("allowNotifications") private var allowNotifications = false
    
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotifications(for multipleItems: [Item], with threshold: Int) {
        removeAllNotifications()
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                for item in multipleItems  {
                    self.scheduleNotification(for: item, with: threshold)
                }
            } else {
                self.requestAuthorization()
                print("Retried request")
            }
        }

    }
    
    func scheduleNotification(for item: Item, with threshold: Int) {
        if let expiration = item.expirationDate, let expiringSoonDate = Calendar.current.date(byAdding: .day, value: -threshold, to: expiration), item.daysUntilExpired()! > 0, allowNotifications {
            // Expiring Soon Notification
            let expiringNotification = UNMutableNotificationContent()
            expiringNotification.title = "\(item.title) Expiring Soon!"
            expiringNotification.subtitle = "You item is expiring soon! Check the app."
            
            var expiringDateComponents = Calendar.current.dateComponents([.month, .day, .year], from: expiringSoonDate)
            expiringDateComponents.hour = 12
            let expiringTrigger = UNCalendarNotificationTrigger(dateMatching: expiringDateComponents, repeats: false)
            let expiringRequest = UNNotificationRequest(identifier: item.id.uuidString + "Expiring", content: expiringNotification, trigger: expiringTrigger)
            
            // Expired Notification
            let expiredNotification = UNMutableNotificationContent()
            expiredNotification.title = "\(item.title) Expired!"
            expiredNotification.subtitle = "You item has expired! Check the app."
            
            var expiredDateComponents = Calendar.current.dateComponents([.month, .day, .year], from: expiration)
            expiredDateComponents.hour = 12
            let expiredTrigger = UNCalendarNotificationTrigger(dateMatching: expiredDateComponents, repeats: false)
            let expiredRequest = UNNotificationRequest(identifier: item.id.uuidString + "Expired", content: expiredNotification, trigger: expiredTrigger)
            
            UNUserNotificationCenter.current().add(expiringRequest)
            UNUserNotificationCenter.current().add(expiredRequest)
            print("Scheduled \(item.title)")
        }
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func removeNotification(withIdentifier identifier: String) {
        let identifiers = [identifier + "Expiring", identifier + "Expired"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func updateNotifications(for item: Item, with threshold: Int) {
        removeNotification(withIdentifier: item.id.uuidString)
        scheduleNotification(for: item, with: threshold)
    }
}
