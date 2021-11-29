//
//  AllItemsView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/28/21.
//

import SwiftUI

struct AllItemsView: View {
    @EnvironmentObject var store: ItemStore
    
    var body: some View {
        VStack {
            HStack {
                Text("All Items")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]) {
                ForEach(store.items) { item in
                    ItemView(item: item)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct AllItemsView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    static var previews: some View {
        AllItemsView()
            .environmentObject(itemStore)
    }
}
