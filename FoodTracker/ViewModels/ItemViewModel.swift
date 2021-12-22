//
//  ItemViewModel.swift
//  FoodTracker
//
//  Created by Gael G. on 12/15/21.
//

import Foundation
import Combine
import SwiftUI

class ItemViewModel: ObservableObject {
    
    @Published var allItems: [Item] = []
    @Published var expiringSoon: [Item] = []
    @Published var searchText: String = ""
    @Published var searchResults: [Item] = []
    @Published var threhold: Int
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        @AppStorage("threshold") var threshold = 5
        self.threhold = threshold
        reload()
        addSubscribers()
    }
    
    init(items: [Item]) {
        threhold = 5
        self.allItems = items
        addSubscribers()
    }
    
    func addSubscribers() {
        // Creates an [Item] of Search Results from Search Text
        $searchText
            .combineLatest($allItems)
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .map(filterItemsSearch)
            .sink { [weak self] returnedData in
                self?.searchResults = returnedData
            }
            .store(in: &cancellables)
        // Creates an [Item] of Items "Expiring Soon"
        $allItems
            .combineLatest($threhold)
            .map(filterExpiringItems)
            .sink { [weak self] returnedData in
                self?.expiringSoon = returnedData
            }
            .store(in: &cancellables)
    }
    
    private func filterItemsSearch(text: String, items: [Item]) -> [Item] {
        guard !text.isEmpty else {
            return items
        }
        let lowercasedText = text.lowercased()
        return items.filter { item in
            return item.title.lowercased().contains(lowercasedText) || item.note.lowercased().contains(lowercasedText)
        }
    }
    
    private func filterExpiringItems(items: [Item], threhold: Int) -> [Item] {
        return items
            .filter { $0.daysUntilExpired() ?? threhold + 1 <= threhold }
            .sorted { $0.expirationDate! < $1.expirationDate! }
    }
    
    /// Re-fetches items from CoreData and adds them to allItems
    func reload() {
        // Gets saved items from CoreDate
        allItems = CoreDataManager.shared.fetch().map({ item in
            Item(id: item.id ?? UUID(), title: item.title ?? "Title", quantity: item.quantity, note: item.note ?? "", expirationDate: item.expirationDate, objectID: item.objectID)
        })
        // Sorts items by expiration date
        allItems.sort { $0.expirationDate ?? Date(timeIntervalSince1970: 0) > $1.expirationDate ?? Date(timeIntervalSince1970: 0) }
    }
    
    /// Saves an individual item to CoreData
    /// - Parameter input: Item to be saved
    func save(input: Item) {
        let item = ItemEntity(context: CoreDataManager.shared.viewContext)
        item.id = input.id
        item.title = input.title
        item.quantity = input.quantity
        item.note = input.note
        item.expirationDate = input.expirationDate
        CoreDataManager.shared.save()
        reload()
    }
    
    /// Creates a new item, creates notifications for item, and saves to CoreData
    /// - Parameters:
    ///   - title: Title of item
    ///   - quantity: Quanity of itme
    ///   - note: Note for item
    ///   - expirationDate: Expiration date for item
    func addItem(title: String, quantity: Double, note: String, expirationDate: Date?) {
        let item = Item(title: title, quantity: quantity, note: note, expirationDate: expirationDate)
        NotificationManager().scheduleNotification(for: item, with: threhold)
        save(input: item)
    }
    
    /// Removes notifications for item and removes from CoreData
    /// - Parameter item: Item to remove
    func deleteItem(item: Item) {
        NotificationManager().removeNotification(withIdentifier: item.id.uuidString)
        if let entity = CoreDataManager.shared.getItem(by: item.objectID!) {
            CoreDataManager.shared.delete(entity: entity)
        }
        reload()
    }
    
    /// Removes multiple items and their notifications
    /// - Parameter items: Items to remove
    func deleteItems(items: [Item]) {
        for item in items {
            deleteItem(item: item)
        }
    }
    
    /// Changes an existing items information in CoreData
    /// - Parameters:
    ///   - item: Old item to replace
    ///   - title: New title
    ///   - quantity: New quantity
    ///   - note: New note
    ///   - expirationDate: New expiration date
    func updateItem(item: Item, title: String, quantity: Double, note: String, expirationDate: Date?) {
        // Check if items exists in CoreData
        if let entity = CoreDataManager.shared.getItem(by: item.objectID!) {
            // Create new item with old id
            let newItem = Item(id: item.id, title: title, quantity: quantity, note: note, expirationDate: expirationDate)
            // Update item in CoreData
            CoreDataManager.shared.update(entity: entity, item: newItem)
            // Update notification
            NotificationManager().updateNotifications(for: newItem, with: threhold)
        }
        reload()
    }
    
    /// Updates threshold in ViewModel
    /// - Parameter threshold: new value for threshold
    func updateThreshold(to threshold: Int) {
        self.threhold = threshold
    }
    
}
