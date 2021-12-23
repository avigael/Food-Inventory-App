//
//  SearchView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/15/21.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var vm: ItemViewModel
    
    @Binding var searchText: String
    @State private var editingItem: Item?
    
    var body: some View {
        ScrollView {
            searchBar
            searchResults
        }
        .padding(.horizontal)
        .sheet(item: $editingItem) { item in
            EditItemView(item: item)
        }
        .onDisappear {
            // Clears text when user leaves screen
            searchText = ""
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView(searchText: .constant(""))
                .environmentObject(sample.vm)
        }
    }
}

extension SearchView {
    
    /// Search bar where user types desired search term
    private var searchBar: some View {
        VStack {
            // Search field
            TextField("Ex. Milk", text: $searchText)
                .submitLabel(.search)
                .padding()
                // Clear search button
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .foregroundColor(Color.theme.background)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                        }
                    , alignment: .trailing
                )
        }
        .frame(height: 50)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
        .padding(.vertical)
    }
    
    /// Results from searching
    private var searchResults: some View {
        VStack {
            // Tells user no items exist
            if vm.searchResults.isEmpty {
                Text("No results")
                    .font(.callout)
                    .padding()
            }
            // Content
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                ForEach(vm.searchResults) { item in
                    ItemView(item: item)
                        .onTapGesture {
                            editingItem = item
                        }
                }
            }
        }
    }
}
