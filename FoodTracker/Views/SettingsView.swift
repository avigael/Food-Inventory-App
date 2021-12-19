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
    
    @State var currentThreshold: Int
    @State var resetAlert = false
    @State var showImagePicker = false
    @Binding var image: UIImage
    @State var notifications = false
    
    enum Theme: String, CaseIterable, Identifiable {
        case light
        case dark
        case system
        var id: Theme { self }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Appearance") {
                    Picker("Theme", selection: $systemTheme, content: {
                        ForEach(Theme.allCases, content: { theme in
                            Text(theme.rawValue.capitalized)
                        })
                    })
                }
                
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
                
                Section {
                    Toggle("Notifications", isOn: $notifications)
                        .onChange(of: notifications) { newValue in
                            if newValue {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        notifications = true
                                    } else {
                                        notifications = false
                                    }
                                }
                                NotificationManager().scheduleNotifications(for: vm.allItems, with: vm.threhold)
                                UNUserNotificationCenter.current().getNotificationSettings { settings in
                                    if settings.authorizationStatus == .authorized {
                                        notifications = true
                                    } else {
                                        notifications = false
                                    }
                                }
                            } else {
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
        SettingsView(currentThreshold: 5, image: sample.$image)
            .environmentObject(sample.vm)
    }
}

extension SettingsView {
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
