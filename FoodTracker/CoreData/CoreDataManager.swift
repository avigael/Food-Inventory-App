//
//  CoreDataManager.swift
//  FoodTracker
//
//  Created by Gael G. on 12/15/21.
//

import Foundation
import CoreData

class CoreDataManager {
        
    let container: NSPersistentContainer
    static let shared = CoreDataManager()
    
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Error saving: \(error)")
        }
        
    }
    
    func fetch() -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }
    
    func delete(entity: ItemEntity) {
        viewContext.delete(entity)
        save()
    }
    
    func update(entity: ItemEntity, item: Item) {
        entity.id = item.id
        entity.title = item.title
        entity.quantity = item.quantity
        entity.note = item.note
        entity.expirationDate = item.expirationDate
        save()
    }
    
    func getItem(by id: NSManagedObjectID) -> ItemEntity? {
        do {
            return try viewContext.existingObject(with: id) as? ItemEntity
        } catch {
            print("Error getting item by ID: \(error)")
            return nil
        }
    }
    
    private init() {
        container = NSPersistentContainer(name: "ItemContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading CoreData: \(error)")
            }
        }
    }
}
