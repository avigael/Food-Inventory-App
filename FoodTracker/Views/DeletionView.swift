//
//  DeletionView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/15/21.
//

import SwiftUI

struct DeletionView: View {
    
    @EnvironmentObject var vm: ItemViewModel
    
    @State var showingAlert: Bool = false
    
    @State var selectedItems: [Item] = []
    @State var selectToggle = false
    
    var body: some View {
        ScrollView {
            // Tells user no items exist
            if vm.allItems.isEmpty {
                Text("You do not have any items")
                    .font(.callout)
                    .padding()
            }
            // Conten
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                ForEach(vm.allItems) { item in
                    ItemView(item: item)
                    // Tap to individually select item
                        .onTapGesture {
                            selectItem(item: item)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(isSelected(item: item) ? .blue : .clear, lineWidth: 5)
                        )
                }
            }
            .padding()
        }
        .toolbar {
            // Select/Deselect Button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if selectToggle {
                        deselectAll()
                    } else {
                        selectAll()
                    }
                    selectToggle.toggle()
                } label: {
                    Text(selectToggle ? "Deselect All" : "Select All")
                }
                .disabled(vm.allItems.isEmpty)
                
            }
            // Delete Button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingAlert = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(selectedItems.isEmpty)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Delete Items?"),
                          message: Text("This action cannot be undone!"),
                          primaryButton: Alert.Button.destructive(Text("Delete")) {
                            vm.deleteItems(items: selectedItems)
                    },
                          secondaryButton: Alert.Button.cancel(Text("Cancel")))
                }
            }
        }
    }
}

struct DeletionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeletionView()
                .environmentObject(sample.vm)
                .navigationTitle("Delete Items")
        }
    }
}

extension DeletionView {
    /// Adds item if it has been not been selected and unselects item if it has been selected.
    /// - Parameter item: Item to select/deselect
    func selectItem(item: Item) {
        if let index = selectedItems.firstIndex(where: {$0.id == item.id}) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
    }
    
    /// Checks if an items has been selected
    /// - Parameter item: Item that will be checked
    /// - Returns: Returns true item has been selected
    func isSelected(item: Item) -> Bool {
        return selectedItems.contains(where: {$0.id == item.id})
    }
    
    /// Adds all items to selections
    func selectAll() {
        selectedItems = vm.allItems
    }
    
    /// Remove all items from selections
    func deselectAll() {
        selectedItems = []
    }
}
