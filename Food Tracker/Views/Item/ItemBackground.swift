//
//  ItemBackground.swift
//  Food Tracker
//
//  Created by Gael G. on 11/28/21.
//

import SwiftUI

struct ItemBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var item: Item
    
    var body: some View {
        let daysLeft = item.daysUntilExpired()
        let backgroundColor = colorScheme == .dark ? Color.darkAccent : Color.lightAccent
        RoundedRectangle(cornerRadius: 15)
            .strokeBorder(item.isSelected ? Color.selectColor : .clear, lineWidth: 5)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill((daysLeft < 0 && !item.cantExpire) ? Color.expiredColor : backgroundColor)
                )
            .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 0)
    }
}

struct ItemBackground_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    static var previews: some View {
        ItemBackground(item: itemStore.items[0])
            .previewLayout(.fixed(width: 150, height: 150))
    }
}
