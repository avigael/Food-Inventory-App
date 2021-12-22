//
//  FoodTrackerApp.swift
//  FoodTracker
//
//  Created by Gael G. on 12/12/21.
//

import SwiftUI

@main
struct FoodTrackerApp: App {
    
    @StateObject var itemViewModel = ItemViewModel()
    @AppStorage("systemTheme") private var systemTheme = SettingsView.Theme.system
        
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .preferredColorScheme(colorScheme(systemTheme))
                    .navigationBarHidden(true)
            }
            .environmentObject(itemViewModel)
        }
    }
    
    /// Converts the Theme Enum to a ColorScheme
    /// - Parameter theme: Enum which represents Light, Dark, and System color themes
    /// - Returns: A color scheme
    func colorScheme(_ theme: SettingsView.Theme) -> ColorScheme? {
        switch theme {
        case .light:
            return ColorScheme.light
        case .dark:
            return ColorScheme.dark
        default:
            return nil
        }
    }
}
