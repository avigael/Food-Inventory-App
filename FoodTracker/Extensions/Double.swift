//
//  Double.swift
//  FoodTracker
//
//  Created by Gael G. on 12/15/21.
//

import Foundation

extension Double {
    /// Converts a Double into a 2 decimal String.
    /// If Double is a whole number String will not include decimals.
    /// ```
    /// Converts 1.0 to "1"
    /// Converts 1.0001 to "1.00"
    /// Converts 1.2345 to "1.23"
    /// ```
    func as2DecimalString() -> String {
        if self == Double(Int(self)) {
            return String(Int(self))
        }
        return String(format: "%.2f", self)
    }
}
