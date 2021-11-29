//
//  EditView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/28/21.
//

import SwiftUI

struct EditView: View {
    
    private enum Field: Int, CaseIterable {
        case name, note
    }
    
    @FocusState private var focusedField: Field?
    
    @EnvironmentObject var store: ItemStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var item: Item
    @State var showingAlert: Bool = false
    @State var name: String
    @State var quantity: Int
    @State var note: String
    @State var cantExpire: Bool
    @State var date: Date
    
    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField("Name", text: $name)
                        .focused($focusedField, equals: .name)
                }
                
                Section("Date") {
                    if !cantExpire {
                        DatePicker("Expiration Date", selection: $date, displayedComponents: [.date])
                    }
                    Toggle("Never Expires", isOn: $cantExpire)
                }
                
                Section("Quantity") {
                    Stepper("\(quantity)", value: $quantity, in: 1...99)
                }
                
                Section("Note") {
                    TextEditor(text: $note)
                        .frame(height: 100)
                        .focused($focusedField, equals: .note)
                }
                
                Section {
                    Button(role: .destructive) {
                        showingAlert = true
                    } label: {
                        Text("Delete Item")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Delete Item?"),
                              message: Text("This action cannot be undone!"),
                              primaryButton: Alert.Button.destructive(Text("Delete")) { store.removeItem(item) },
                              secondaryButton: Alert.Button.cancel(Text("Cancel")))
                    }
                }
            }
            .navigationTitle(name.isEmpty ? "Edit Item" : "\(name)")
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update") {
                        store.replaceItem(item, name: name, quantity: quantity, expiration: date, cantExpire: cantExpire, note: note)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    @State static var item = itemStore.items[0]
    static var previews: some View {
        EditView(item: item, name: item.name, quantity: item.quantity, note: item.note, cantExpire: item.cantExpire, date: item.expiration)
    }
}
