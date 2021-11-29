//
//  SettingsView.swift
//  Food Tracker
//
//  Created by Gael G. on 11/29/21.
//

import SwiftUI

struct SettingsView: View {
    enum Theme: String, CaseIterable, Identifiable {
        case light
        case dark
        case system
        var id: Theme { self }
    }
    
    @AppStorage("systemTheme") private var systemTheme = Theme.system
    
    @EnvironmentObject var store: ItemStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var notifications: Bool = false
    @State var threshold: Int
    @State var resetAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $systemTheme, content: {
                        ForEach(Theme.allCases, content: { theme in
                            Text(theme.rawValue.capitalized)
                        })
                    })
                }
                Section("Notifications") {
                    Toggle("Allow Notifications", isOn: $notifications)
                }
                Section("Expiring Soon Threshold") {
                    Stepper(value: $threshold, in: 1...30) {
                        Text("\(threshold) " + (threshold == 1 ? "Day" : "Days"))
                    }
                }
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.1")
                    }
                    HStack {
                        Text("Support")
                        Spacer()
                        Text("info@gael.cc")
                    }
                }
                Section {
                    Button {
                        resetAlert = true
                    } label: {
                        Text("Reset Settings")
                    }
                    .alert(isPresented: $resetAlert) {
                        Alert(title: Text("Reset Settings?"),
                              message: Text("Settings will revert to their default!"),
                              primaryButton: Alert.Button.default(Text("Confirm")) {
                            systemTheme = Theme.system
                            threshold = 4
                            store.updateThreshold(threshold)
                        },
                              secondaryButton: Alert.Button.cancel(Text("Cancel")))
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        store.updateThreshold(threshold)
                        presentationMode.wrappedValue.dismiss()
                    }
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

struct SettingsView_Previews: PreviewProvider {
    @StateObject static var itemStore = ItemStore()
    @State static var threshold = 4
    static var previews: some View {
        SettingsView(threshold: threshold)
            .environmentObject(itemStore)
    }
}
