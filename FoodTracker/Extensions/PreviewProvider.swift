//
//  PreviewProvider.swift
//  FoodTracker
//
//  Created by Gael G. on 12/14/21.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var sample: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    /// A collection of custom items for testing
    /// - An default item:
    /// **item.standard**
    /// - An expired item:
    /// **item.expired**
    /// - An item with no expiration:
    /// **item.neverExpires**
    /// - An item with a long title:
    /// **item.longTitle**
    /// - An item with a short title:
    /// **item.shortTitle**
    /// - An item without a note:
    /// **item.withoutNote**
    /// - An item with a long note:
    /// **item.withLongNote**
    /// - An item with a large quantity:
    /// **item.largeQuantity**
    let item = ItemExamples()
    
    @State var image = UIImage(imageLiteralResourceName: "Dark-Image")
    
    let vm = ItemViewModel(items: [
        Item(title: "Animal Cracker Box", quantity: 4, note: "For Sam's school lunch!", expirationDate: Date(timeIntervalSinceNow: 180*24*60*60)),
        Item(title: "Frosted Flakes Cereal", note: "Family sized box", expirationDate: Date(timeIntervalSinceNow: 30*24*60*60)),
        Item(title: "Cheese Whiz", expirationDate: Date(timeIntervalSinceNow: -5*24*60*60)),
        Item(title: "1/2 Egg McMuffin", quantity: 0.5, note: "At this on Dec 14th. Should eat it soon.", expirationDate: Date(timeIntervalSinceNow: 12*60*60)),
        Item(title: "White Sugar Bag", quantity: 0.9, note: "Bag is 1kg fyi", expirationDate: nil),
        Item(title: "Bread Flour Bag", quantity: 0.75, note: "This is bread flour for my bread, do not us for anything besides bread", expirationDate: Date(timeIntervalSinceNow: 265*24*60*60)),
        Item(title: "Vintage Scotch 1974", quantity: 0.25, note: "This is in the basement behind the countertop", expirationDate: nil),
        Item(title: "Strawberries", quantity: 12, note: "These get moldy fast btw", expirationDate: Date(timeIntervalSinceNow: -7*24*60*60)),
        Item(title: "Dried Blueberries", quantity: 4, note: "I bought 4 bags for the trailmix probably will have 2 left for next week", expirationDate: Date(timeIntervalSinceNow: 80*24*60*60)),
        Item(title: "Japanese Honey Dew Melon Candies", quantity: 21, note: "Remember to save some for Joe when he gets back from his trip", expirationDate: Date(timeIntervalSinceNow: 430*24*60*60)),
        Item(title: "Dates", quantity: 99, note: "Bought a jumbo pack, btw these are pitted", expirationDate: Date(timeIntervalSinceNow: 10*24*60*60))
    ])
}

struct ItemExamples {
    let standard = Item(title: "White Bread", quantity: 1, note: "This bread isn't as soft as I like so eat as much as you like", expirationDate: Date(timeIntervalSinceNow: 600_000))
    let expired = Item(title: "Cinnamon Buns", quantity: 3, note: "Got at Whole Foods 1/2 off", expirationDate: Date(timeIntervalSinceNow: -602_000))
    let neverExpires = Item(title: "Lavender Honey", quantity: 1, note: "1 gallon of honey from a local beekeeper", expirationDate: nil)
    let longTitle = Item(title: "Blueberry Muffins with Chocolate Topping", quantity: 2, note: "There are behind the middle shelf", expirationDate: Date(timeIntervalSinceNow: 86_400))
    let shortTitle = Item(title: "Milk", quantity: 0.95, note: "Save some milk for breakfast cereal", expirationDate: Date(timeIntervalSinceNow: 86_000))
    let withoutNote = Item(title: "Swiss Cheese")
    let withLongNote = Item(title: "Strawberries", quantity: 12, note: "Strawberries from the berry event I went to in June. They are pretty magical since they last longer than normal strawberries. At least that is what the sales person told me. He said they shouldn't expire for at least a month. I'm thinking of dipping them in chocolate.", expirationDate: Date(timeIntervalSinceNow: 3_000_000))
    let largeQuantity = Item(title: "Mini Chocolate Chips", quantity: 1022, expirationDate: Date(timeIntervalSinceNow: 1_000_000))
    
    fileprivate init () {}
}
