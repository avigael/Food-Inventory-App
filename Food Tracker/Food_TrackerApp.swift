//
//  Food_TrackerApp.swift
//  Food Tracker
//
//  Created by Gael G. on 11/28/21.
//

import SwiftUI

@main
struct Food_TrackerApp: App {
    @StateObject var itemStore = ItemStore()
    @AppStorage("systemTheme") private var systemTheme = SettingsView.Theme.system
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(colorScheme(systemTheme))
                .environmentObject(itemStore)
        }
    }
    
    func colorScheme(_ theme: SettingsView.Theme) -> ColorScheme? {
        switch theme {
        case .light:
            return ColorScheme.light
        case .dark:
            return ColorScheme.dark
        default:
            return .none
        }
    }
}
