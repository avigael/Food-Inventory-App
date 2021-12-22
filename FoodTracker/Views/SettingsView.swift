//
//  SettingsView.swift
//  FoodTracker
//
//  Created by Gael G. on 12/16/21.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    
    @EnvironmentObject var vm: ItemViewModel
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("threshold") private var threshold = 5
    @AppStorage("systemTheme") private var systemTheme = Theme.system
    
    @Binding var image: UIImage
    @State var showImagePicker = false
    @State var currentThreshold: Int
    @State var resetAlert = false
    // TODO: Save notification state
    @State var notifications = false
    
    // List of themes for Picker in settings
    enum Theme: String, CaseIterable, Identifiable {
        case light
        case dark
        case system
        var id: Theme { self }
    }
    
    var body: some View {
        NavigationView {
            List {
                // Theme Picker
                Section("Appearance") {
                    Picker("Theme", selection: $systemTheme, content: {
                        ForEach(Theme.allCases, content: { theme in
                            Text(theme.rawValue.capitalized)
                        })
                    })
                }
                // Background Image Picker
                Section {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 100, height: 100)
                            .padding(.vertical)
                        Divider()
                        Button {
                            showImagePicker = true
                        } label: {
                            HStack {
                                Text("Change Background")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } header: {
                    Text("Background")
                } footer: {
                    Text("Changes the background of the main screen.")
                }
                // Notifications Toggle
                Section {
                    Toggle("Notifications", isOn: $notifications)
                        .onChange(of: notifications) { newValue in
                            if newValue {
                                // Ask for permission
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        // Changes toggle to true
                                        notifications = true
                                    } else {
                                        // If user denies notifications will revert to false
                                        notifications = false
                                    }
                                }
                                // Schedule notifications for all items
                                NotificationManager().scheduleNotifications(for: vm.allItems, with: vm.threhold)
                            } else {
                                // Removes all notifications when toggled off
                                NotificationManager().removeAllNotifications()
                                print("NOTIFICATIONS CLEARED!")
                            }
                        }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Get notifications when items expire and are within the threshold. Enable notifications in your settings if you cannot turn on notifications.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                // Edit Threshold
                Section {
                    Stepper("\(currentThreshold) " + (currentThreshold == 1 ? "Day" : "Days")) {
                        currentThreshold += 1
                    } onDecrement: {
                        if currentThreshold > 1 {
                            currentThreshold -= 1
                        }
                    }
                } header: {
                    Text("Threshold")
                } footer: {
                    Text("When items should be moved to \"Expiring Soon\".")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                // About/Info
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.0")
                    }
                    HStack {
                        Text("Support")
                        Spacer()
                        Text("info@gael.cc")
                    }
                }
                // Reset Settings
                Section {
                    Button(role: .destructive) {
                        resetAlert = true
                    } label: {
                        Text("Reset Settings")
                    }
                    .alert(isPresented: $resetAlert) {
                        Alert(title: Text("Reset Settings?"),
                              message: Text("Settings will revert to their default!"),
                              primaryButton: Alert.Button.default(Text("Confirm")) {
                            systemTheme = Theme.system
                            image = UIImage(imageLiteralResourceName: "Dark-Image")
                            vm.updateThreshold(to: 5)
                            threshold = 5
                        },
                              secondaryButton: Alert.Button.cancel(Text("Cancel")))
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .sheet(isPresented: $showImagePicker, content: {
                PhotoPicker(backgroundImage: $image)
            })
            .toolbar {
                // Save Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if currentThreshold != vm.threhold {
                            vm.updateThreshold(to: currentThreshold)
                            threshold = currentThreshold
                            NotificationManager().scheduleNotifications(for: vm.allItems, with: currentThreshold)
                        }
                        dismiss()
                    }
                }
                // Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(getColor())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(image: sample.$image, currentThreshold: 5)
            .environmentObject(sample.vm)
    }
}

extension SettingsView {
    /// Gets the current selected theme as a ColorScheme
    /// - Returns: User selected ColorScheme
    func getColor() -> ColorScheme? {
        switch systemTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}
