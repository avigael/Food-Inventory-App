//
//  FilteredItemsView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/29/21.
//

import SwiftUI

struct FilteredItemsView: View {
    @EnvironmentObject var store: ItemStore
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Results")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]) {
                ForEach(store.searchItems(for: searchText)) { item in
                    ItemView(item: item)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilteredItemsView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    @State static var searchText = "eggs"
    static var previews: some View {
        FilteredItemsView(searchText: $searchText)
            .environmentObject(itemStore)
    }
}
