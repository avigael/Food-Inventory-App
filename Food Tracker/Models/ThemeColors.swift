//
//  ThemeColors.swift
//  Food Tracker
//
//  Created by Gael G. on 11/29/21.
//

import SwiftUI

extension Color {
    // Backgrounds
    public static var lightMode: Color {
        Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    public static var darkMode: Color {
        Color(red: 0.11, green: 0.11, blue: 0.12)
    }
    
    // Item Colors
    public static var lightAccent: Color {
        Color.white
    }
    
    public static var darkAccent: Color {
        Color(red: 0.17, green: 0.17, blue: 0.17)
    }
    
    public static var expiredColor: Color {
        Color(red: 0.75, green: 0.1, blue: 0.1)
    }
    
    // Item Text Colors
    public static var lightText: Color {
        Color.white
    }
    
    public static var darkText: Color {
        Color.black
    }
    
    public static var expiringText: Color {
        Color.red
    }
    
    // Selection Color
    public static var selectColor: Color {
        Color.blue
    }
    
    // Shadow Color
    public static var shadowColor: Color {
        Color(white: 0, opacity: 0.25)
    }
}
