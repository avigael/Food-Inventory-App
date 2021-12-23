//
//  DeletionView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/15/21.
//

import SwiftUI

struct DeletionView: View {
    
    @EnvironmentObject var vm: ItemViewModel
    
    @State private var selectedItems: [Item] = []
    @State private var selectToggle = false
    @State private var showingAlert: Bool = false

    
    var body: some View {
        listOfAllItems
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                selectionToggle
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                deleteButton
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
    
    /// A scrolling view containing all the items stored
    private var listOfAllItems: some View {
        ScrollView {
            // Display warning if no items exist
            if vm.allItems.isEmpty {
                Text("You do not have any items")
                    .font(.callout)
                    .padding()
            }
            // Content
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                ForEach(vm.allItems) { item in
                    // Tap to individually select item
                    ItemView(item: item)
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
    }
    
    /// Buttons which can toggle between selecting all items and delecting all items
    private var selectionToggle: some View {
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
    
    /// Deletes all selected items
    private var deleteButton: some View {
        // Shows confirmation alert before deleting selected items
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
    
    /// Adds item if it has been not been selected and unselects item if it has been selected.
    /// - Parameter item: Item to select/deselect
    private func selectItem(item: Item) {
        if let index = selectedItems.firstIndex(where: {$0.id == item.id}) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
    }
    
    /// Checks if an items has been selected
    /// - Parameter item: Item that will be checked
    /// - Returns: Returns true item has been selected
    private func isSelected(item: Item) -> Bool {
        return selectedItems.contains(where: {$0.id == item.id})
    }
    
    /// Adds all items to selections
    private func selectAll() {
        selectedItems = vm.allItems
    }
    
    /// Remove all items from selections
    private func deselectAll() {
        selectedItems = []
    }
}
