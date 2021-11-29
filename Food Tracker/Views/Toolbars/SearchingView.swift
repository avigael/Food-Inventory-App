//
//  SearchingView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/29/21.
//

import SwiftUI

struct SearchingView: View {
    @EnvironmentObject var store: ItemStore
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showingSearch: Bool
    @State var items = [Item]()
    @State private var search = ""
    @State var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    search = ""
                    showingSearch = false
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(colorScheme == .dark ? .darkAccent : .lightAccent)
                            .frame(width: 50, height: 50)
                        Image(systemName: "chevron.backward").foregroundColor(colorScheme == .dark ? .lightText : .darkText)
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(colorScheme == .dark ? .darkAccent : .lightAccent)
                    .frame(height: 50)
                    TextField("Search", text: $search)
                        .padding(.horizontal)
                        .onSubmit {
                            searchText = search
                        }
                        .submitLabel(.search)
                }

            }
            .padding(.horizontal)
            .frame(height: 75)
            ScrollView(showsIndicators: false) {
                FilteredItemsView(searchText: $searchText)
            }
        }
    }
}

struct SearchingView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    @State static var showingSearch = false
    static var previews: some View {
        Group {
            SearchingView(showingSearch: $showingSearch)
                .environmentObject(itemStore)
        }
    }
}
