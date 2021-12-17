//
//  Color.swift
//  FoodTracker
//
//  Created by Gael G. on 12/12/21.
//

import Foundation
import SwiftUI

struct ColorTheme {
    let background = Color("Background")
    let accent = Color("Accent")
    let text = Color("Text")
    let expiredText = Color("ExpiredText")
}

extension Color {
    /// Custom colors for app theme
    static let theme = ColorTheme()
}
