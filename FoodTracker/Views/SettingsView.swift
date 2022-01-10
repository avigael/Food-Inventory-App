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
    @AppStorage("allowNotifications") private var allowNotifications = false
    
    @State var image: UIImage
    @State var currentThreshold: Int
    @State var notificationToggle: Bool
    @State private var showImagePicker = false
    @State private var resetAlert = false

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
                themeSection
                backgroundImageSection
                notificationsSection
                thresholdSection
                aboutSection
                resetSettingsSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .sheet(isPresented: $showImagePicker, content: {
                PhotoPicker(backgroundImage: $image)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
            }
        }
        .preferredColorScheme(getColor())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(image: sample.image, currentThreshold: 5, notificationToggle: false)
            .environmentObject(sample.vm)
    }
}

extension SettingsView {
    
    /// Changes the color scheme of the app
    private var themeSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: $systemTheme, content: {
                ForEach(Theme.allCases, content: { theme in
                    Text(theme.rawValue.capitalized)
                })
            })
        }
    }
    
    /// Changes the background image of the app
    private var backgroundImageSection: some View {
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
    }
    
    /// Enables or disables notifications for items
    private var notificationsSection: some View {
        Section {
            Toggle("Notifications", isOn: $notificationToggle)
                .onChange(of: notificationToggle) { newValue in
                    if newValue {
                        // Ask for permission
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                // Changes toggle to true
                                notificationToggle = true
                                allowNotifications = true
                                print("NOTIFICATIONS ALLOWED!")
                            } else {
                                // If user denies notifications will revert to false
                                notificationToggle = false
                                allowNotifications = false
                                print("NOTIFICATIONS DENIED!")
                            }
                        }
                        // Schedule notifications for all items
                        NotificationManager().scheduleNotifications(for: vm.allItems, with: vm.threhold)
                    } else {
                        // Removes all notifications when toggled off
                        NotificationManager().removeAllNotifications()
                        allowNotifications = false
                        print("NOTIFICATIONS CLEARED!")
                    }
                }
        } header: {
            Text("Notifications")
        } footer: {
            Text("Get notifications when items expire and are within the threshold. Items that expire the same day they were added will not recieve a notification. Enable notifications in your settings if you cannot turn on notifications.")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    /// Changes the threshold for "expiring soon"
    private var thresholdSection: some View {
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
    }
    
    /// About sections
    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("3.0")
            }
            HStack {
                Text("Support")
                Spacer()
                Text("info@gael.cc")
            }
        }
    }
    
    /// Resets all settings to default
    private var resetSettingsSection: some View {
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
                    image = UIImage(imageLiteralResourceName: "default-background")
                    vm.saveBackgroundImage(image: image)
                    vm.updateThreshold(to: 5)
                    threshold = 5
                },
                      secondaryButton: Alert.Button.cancel(Text("Cancel")))
            }
        }
    }
    
    /// Saves the current settings
    private var saveButton: some View {
        Button("Save") {
            if currentThreshold != vm.threhold {
                vm.updateThreshold(to: currentThreshold)
                threshold = currentThreshold
                NotificationManager().scheduleNotifications(for: vm.allItems, with: currentThreshold)
            }
            vm.saveBackgroundImage(image: image)
            dismiss()
        }
    }
    
    /// Closes sheet and does nothing
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    /// Gets the current selected theme as a ColorScheme
    /// - Returns: User selected ColorScheme
    private func getColor() -> ColorScheme? {
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
