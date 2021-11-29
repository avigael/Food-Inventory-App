//
//  ItemStore.swift
//  Food Tracker
//
//  Created by Gael G. on 11/28/21.
//

import Foundation

struct Item: Identifiable, Codable {
    let id: UUID            // UNIQUE ITEM ID
    var name: String        // NAME OF ITEM
    var quantity: Int       // QUANTITY OF ITEM
    var expiration: Date    // EXPIRATION DATE OF ITEM
    var cantExpire: Bool    // CAN ITEM EXPIRE? (VOIDS EXPIRATION)
    var note: String        // NOTE FOR ITEM
    var isSelected: Bool    // IS ITEM SELECTED?
    
    fileprivate init(id: UUID = UUID(), name: String, quantity: Int = 1, expiration: Date = Date(), cantExpire: Bool = false, note: String = "", isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.expiration = expiration
        self.cantExpire = cantExpire
        self.note = note
        self.isSelected = isSelected
    }
    
    func daysUntilExpired() -> Int {
        let today = Date()
        let components = Calendar.current.dateComponents([.day], from: today, to: expiration)
        if components.day! > 0 {
            return components.day! + 1
        }
        return components.day!
    }
}

class ItemStore: ObservableObject {
    @Published private(set) var items = [Item]()
    @Published private(set) var threshold: Int = 4
    @Published private(set) var selecting: Bool = false
    
    init() {
        let data = [
            Item(name: "Swiss Cheese", expiration: Date(timeIntervalSinceNow: -604_800), note: "Behind milk jugs in kitchen fridge"),
            Item(name: "Organic Whole Milk", expiration: Date(timeIntervalSinceNow: 604_800)),
            Item(name: "Potato Bread", expiration: Date(timeIntervalSinceNow: 172_800), note: "About 1/2 a loaf left"),
            Item(name: "Eggs", quantity: 12, expiration: Date(timeIntervalSinceNow: 86_400)),
            Item(name: "Ranch Dressing", expiration: Date()),
            Item(name: "Lavendar Honey", cantExpire: true),
            Item(name: "Blueberry Banana Nut Muffins with Almonds", expiration: Date(timeIntervalSinceNow: 432_000), note: "Jerry can eat these. They are gluten free!"),
            Item(name: "Tomatoes", quantity: 7, expiration: Date(timeIntervalSinceNow: 172_800)),
            Item(name: "Candy Bars", quantity: 2, expiration: Date(timeIntervalSinceNow: 31_536_000), note: "Save one for Mom")
        ]
        threshold = 4
        items += data
    }
    
    func addItem(name: String, quantity: Int, expiration: Date, cantExpire: Bool, note: String) {
        items.append(Item(name: name, quantity: quantity, expiration: expiration, cantExpire: cantExpire, note: note))
    }
    
    @discardableResult
    func removeItem(_ item: Item) -> Int? {
        if let index = items.firstIndex(where: {$0.id == item.id}) {
            items.remove(at: index)
            return index
        }
        return nil
    }
    
    func replaceItem(_ item: Item, name: String, quantity: Int, expiration: Date, cantExpire: Bool, note: String) {
        if let index = removeItem(item) {
            items.insert(Item(name: name, quantity: quantity, expiration: expiration, cantExpire: cantExpire, note: note), at: index)
        }
    }
    
    func isSelectedToggle(_ item: Item) {
        var toggle = true
        if item.isSelected {
            toggle = false
        }
        if let index = removeItem(item) {
            items.insert(Item(name: item.name, quantity: item.quantity, expiration: item.expiration, cantExpire: item.cantExpire, note: item.note, isSelected: toggle), at: index)
        }
    }
    
    func selectAll() {
        for index in items.indices {
            let item = items[index]
            items.remove(at: index)
            items.insert(Item(name: item.name, quantity: item.quantity, expiration: item.expiration, cantExpire: item.cantExpire, note: item.note, isSelected: true), at: index)
        }
    }

    func deselectAll() {
        for index in items.indices {
            let item = items[index]
            items.remove(at: index)
            items.insert(Item(name: item.name, quantity: item.quantity, expiration: item.expiration, cantExpire: item.cantExpire, note: item.note, isSelected: false), at: index)
        }
    }
    
    func selectingOn() {
        selecting = true
    }
    
    func selectingOff() {
        selecting = false
    }
    
    func removeSelected() {
        items.removeAll(where: {$0.isSelected})
    }
    
    func checkExpiring() -> Bool {
        return items.contains(where: {$0.daysUntilExpired() < threshold && !$0.cantExpire})
    }
    
    func updateThreshold(_ threshold: Int) {
        self.threshold = threshold
    }
    
    func searchItems(for name: String) -> [Item] {
        var results = [Item]()
        for item in items {
            let itemName = item.name.lowercased()
            let targetName = name.lowercased()
            if itemName.contains(targetName) || targetName.contains(itemName) {
                results.append(item)
            }
        }
        return results
    }
}
