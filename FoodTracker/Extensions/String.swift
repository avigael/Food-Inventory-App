//
//  String.swift
//  FoodTracker
//
//  Created by Gael G. on 12/15/21.
//

import Foundation

extension String {

    /// Converts a string to a Double with 2 decimal places
    /// ```
    /// Converts "1.2345" to Optional(1.23)
    /// ```
    /// - Returns: Optional 2 decimal Double if String could not be converted
    func asDouble() -> Double? {
        if let double = Double(self) {
            return round(double * 100) / 100.0
        }
        return nil
    }
}
