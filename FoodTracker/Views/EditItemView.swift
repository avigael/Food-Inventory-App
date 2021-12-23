//
//  EditItemView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/15/21.
//

import SwiftUI

struct EditItemView: View {
    
    @EnvironmentObject var vm: ItemViewModel
    @Environment(\.dismiss) var dismiss
    
    private var currentItem: Item?
    @State private var title: String
    @State private var quantity: String = ""
    @State private var note: String
    @State private var expirationDate: Date
    @State private var voidExpiration: Bool
    
    @State var showingAlert: Bool = false
    
    init(item: Item) {
        currentItem = item
        _title = .init(initialValue: item.title)
        _quantity = .init(initialValue: String(item.quantity))
        _note = .init(initialValue: item.note)
        if let expiration = item.expirationDate {
            _expirationDate = .init(initialValue: expiration)
            _voidExpiration = .init(initialValue: false)
        } else {
            _expirationDate = .init(initialValue: Date())
            _voidExpiration = .init(initialValue: true)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                titleSection
                dateSection
                quantitySection
                noteSection
                deleteButton
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    updateButton
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
            }
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: sample.item.standard)
    }
}

extension EditItemView {
    
    /// Edit title of item
    private var titleSection: some View {
        Section("Title (required)") {
            TextField("Item Name", text: $title)
        }
    }
    
    /// Edit expiration date of item
    private var dateSection: some View {
        Section {
            if !voidExpiration {
                DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: [.date])
            }
            Toggle("No Expiration Date", isOn: $voidExpiration)
        } header: {
            Text("Date")
        } footer: {
            Text("Enabling no expiration date means this item does not expire.")
        }
    }
    
    /// Edit quantity of item
    private var quantitySection: some View {
        Section {
            /// Make red if input is not a number or below 0.1
            TextField("Ex. 0.5", text: $quantity)
                .keyboardType(.decimalPad)
                .foregroundColor(checkDoubleString(quantity) ? Color.theme.text : Color.theme.expiredText)
        } header: {
            Text("Quantity (required)")
        } footer: {
            Text("Only quantities of 0.1 or larger are valid.")
        }
    }
    
    /// Edit note of item
    private var noteSection: some View {
        Section("Notes") {
            TextEditor(text: $note)
                .frame(height: 100)
        }
    }
    
    /// Delete item
    private var deleteButton: some View {
        Section {
            // Shows a confirmation alert before deleting
            Button(role: .destructive) {
                showingAlert = true
            } label: {
                Text("Delete Item")
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Delete Item?"),
                      message: Text("This action cannot be undone!"),
                      primaryButton: Alert.Button.destructive(Text("Delete")) {
                        vm.deleteItem(item: currentItem!)
                        dismiss()
                },
                      secondaryButton: Alert.Button.cancel(Text("Cancel")))
            }
        }
    }
    
    
    /// Updates with new information
    private var updateButton: some View {
        Button {
            // Makes expiration nil if No Expiration Date enabled
            var expiration: Date? = expirationDate
            if voidExpiration {
                expiration = nil
            }
            // Updates item
            vm.updateItem(item: currentItem!, title: title, quantity: quantity.asDouble()!, note: note, expirationDate: expiration)
            dismiss()
        } label: {
            HStack {
                Image(systemName: "pencil.circle")
                Text("Update")
            }
        }
        .disabled(title.isEmpty || !checkDoubleString(quantity))
    }
    
    /// Closes sheet and does nothing
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    /// Checks if quantity is a valid input
    /// - Parameter double: String which can convert to a double
    /// - Returns: If string cannot convert to a double or is less than 0.1 return false
    private func checkDoubleString(_ double: String) -> Bool {
        if let value = double.asDouble(), value >= 0.1 {
            return true
        }
        return false
    }
}
