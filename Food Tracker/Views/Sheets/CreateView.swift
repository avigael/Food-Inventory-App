//
//  CreateView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/29/21.
//

import SwiftUI

struct CreateView: View {
    private enum Field: Int, CaseIterable {
        case name, note
    }
    @FocusState private var focusedField: Field?
    
    @EnvironmentObject var store: ItemStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String = ""
    @State var quantity: Int = 1
    @State var note: String = ""
    @State var cantExpire: Bool = false
    @State var date: Date = Date()
    
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
            }
            .navigationTitle(name.isEmpty ? "Create Item" : "\(name)")
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
                    Button {
                        store.addItem(name: name, quantity: quantity, expiration: date, cantExpire: cantExpire, note: note)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add")
                        }
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

struct CreateView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    static var previews: some View {
        CreateView()
            .environmentObject(itemStore)
    }
}
