//
//  BarcodeResult.swift
//  FoodTracker
//
//  Created by Gael G. on 1/8/22.
//

import Foundation
import SwiftUI

struct BarcodeResult: Codable {
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case results = "hints"
    }
}

struct Result: Codable {
    let food: Food
}

struct Food: Codable {
    let label: String
    let brand: String?
}
