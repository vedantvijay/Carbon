//
//  AppColors.swift
//  carbon
//
//  Created by Vedant Vijay on 06/02/26.
//

import SwiftUI

/// Shared color palette for the entire app.
/// Centralises every repeated color so changes propagate everywhere.
enum AppColors {
    
    // MARK: - Brand
    
    /// Primary accent used across the app (buttons, highlights, icons).
    static let accent = Color(red: 0.1, green: 0.9, blue: 0.6)
    
    // MARK: - Category Colors
    
    static let travel   = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let food     = Color(red: 0.9, green: 0.6, blue: 0.3)
    static let energy   = Color(red: 0.9, green: 0.4, blue: 0.4)
    static let shopping = Color(red: 0.7, green: 0.5, blue: 0.9)
    
    /// Returns the brand color for a given emission category.
    static func color(for category: EmissionCategory) -> Color {
        switch category {
        case .travel:   return travel
        case .food:     return food
        case .energy:   return energy
        case .shopping: return shopping
        }
    }
    
    // MARK: - Quick Action Colors
    
    static let actionBlue   = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let actionOrange = Color(red: 0.9, green: 0.6, blue: 0.3)
    static let actionLime   = Color(red: 0.6, green: 0.9, blue: 0.4)
}
