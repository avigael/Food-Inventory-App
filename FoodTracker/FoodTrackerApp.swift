//
//  FoodTrackerApp.swift
//  FoodTracker
//
//  Created by Gael G. on 12/12/21.
//

import SwiftUI

@main
struct FoodTrackerApp: App {
    @AppStorage("systemTheme") private var systemTheme = SettingsView.Theme.system
    
    @StateObject var itemViewModel = ItemViewModel()
    
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
