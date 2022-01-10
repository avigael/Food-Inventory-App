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
        
    @State private var showAlert = false
    @State private var showScanner = false
    
    @State private var title: String = ""
    @State private var quantity: String = "1"
    @State private var note: String = ""
    @State private var expirationDate: Date = Date()
    @State private var voidExpiration: Bool = false
    
    var body: some View {
        NavigationView {
            if showScanner {
                BarcodeScanner(label: $title, showScanner: $showScanner, showAlert: $showAlert)
                .navigationTitle("Scan Barcode")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        cancelCameraButton
                    }
                }
            } else {
                List {
                    titleSection
                    dateSection
                    quantitySection
                    noteSection
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Add Item")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        createButton
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        cancelButton
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("No Name Found!"),
                        message: Text("Could not find an item for this barcode.")
                    )
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
    /// Add title to item
    private var titleSection: some View {
        Section("Title (required)") {
            HStack {
                TextField("Item Name", text: $title)
                    .submitLabel(.done)
                Image(systemName: "barcode.viewfinder")
                    .resizable()
                    .foregroundColor(Color.theme.accent)
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        showScanner = true
                    }
            }
        }
    }
    
    /// Add expiration date or turn off expiration for item
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
    
    /// Add the quantity of an item
    private var quantitySection: some View {
        Section {
            TextField("Ex. 0.5", text: $quantity)
                .keyboardType(.decimalPad)
                .foregroundColor(checkDoubleString(quantity) ? Color.theme.text : Color.theme.expiredText)
        } header: {
            Text("Quantity (required)")
        } footer: {
            Text("Only quantities of 0.1 or larger are valid.")
        }
    }
    
    /// Add a note for an item
    private var noteSection: some View {
        // Add note
        Section("Notes") {
            TextEditor(text: $note)
                .frame(height: 100)
        }
    }
    
    /// Adds newly created item
    private var createButton: some View {
        Button {
            // Makes expiration nil if No Expiration Date enabled
            var expiration: Date? = expirationDate
            if voidExpiration {
                expiration = nil
            }
            // Adds item
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
    
    /// Closes sheet and saves nothing
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    /// Closes camera and reverts back to Add Item screen
    private var cancelCameraButton: some View {
        Button("Cancel") {
            showScanner = false
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
