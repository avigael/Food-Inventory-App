//
//  AddItemView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/15/21.
//

import SwiftUI

struct AddItemView: View {
    
    @EnvironmentObject var vm: ItemViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var title: String = ""
    @State var quantity: String = "1"
    @State var note: String = ""
    @State var expirationDate: Date = Date()
    @State var voidExpiration: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                // Add title
                Section("Title (required)") {
                    TextField("Item Name", text: $title)
                }
                // Add expiration date
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
                // Add quantity
                Section {
                    TextField("Ex. 0.5", text: $quantity)
                        .keyboardType(.decimalPad)
                        .foregroundColor(checkDoubleString(quantity) ? Color.theme.text : Color.theme.expiredText)
                } header: {
                    Text("Quantity (required)")
                } footer: {
                    Text("Only quantities of 0.1 or larger are valid.")
                }
                // Add note
                Section("Notes") {
                    TextEditor(text: $note)
                        .frame(height: 100)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add Item")
            .toolbar {
                // Add New Item Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Makes expiration nil if no expiration
                        var expiration: Date? = expirationDate
                        if voidExpiration {
                            expiration = nil
                        }
                        vm.addItem(title: title, quantity: quantity.asDouble()!, note: note, expirationDate: expiration)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add")
                        }
                    }
                    .disabled(title.isEmpty || !checkDoubleString(quantity))
                }
                // Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}

extension AddItemView {
    /// Checks if quantity is a valid input
    /// - Parameter double: String which can convert to a double
    /// - Returns: If string cannot convert to a double or is less than 0.1 return false
    func checkDoubleString(_ double: String) -> Bool {
        if let value = double.asDouble(), value >= 0.1 {
            return true
        }
        return false
    }
}
