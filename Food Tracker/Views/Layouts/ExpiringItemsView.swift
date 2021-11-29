//
//  ExpiringItemsView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/29/21.
//

import SwiftUI

struct ExpiringItemsView: View {
    @EnvironmentObject var store: ItemStore
    
    var body: some View {
        VStack {
            HStack{
                Text("Expiring Soon")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.adaptive(minimum: 130))]) {
                    ForEach(store.items) { item in
                        if item.daysUntilExpired() < store.threshold && !item.cantExpire {
                            ItemView(item: item)
                        }
                    }
                }
                .padding()
            }
            .frame(minHeight: 180)
        }
    }
}

struct ExpiringItemsView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    static var previews: some View {
        ExpiringItemsView()
            .environmentObject(itemStore)
    }
}
