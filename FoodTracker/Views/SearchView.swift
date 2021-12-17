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
    @State var editingItem: Item?
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Ex. Milk", text: $searchText)
                    .submitLabel(.search)
                    .padding()
            }
            .frame(height: 50)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
            .padding(.vertical)
            if vm.searchResults.isEmpty {
                Text("No results")
                    .font(.callout)
                    .padding()
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                ForEach(vm.searchResults) { item in
                    ItemView(item: item)
                        .onTapGesture {
                            editingItem = item
                        }
                }
            }
        }
        .padding(.horizontal)
        .sheet(item: $editingItem) { item in
            EditItemView(item: item)
        }
        .onDisappear {
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
