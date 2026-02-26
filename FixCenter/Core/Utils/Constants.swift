//
//  Constants.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import SwiftUI

enum AppConstants {
    static let cornerRadius: CGFloat = 16
    static let cardPadding: CGFloat = 16
    static let animationDuration: Double = 0.3
    static let blurRadius: CGFloat = 20
}

enum AppColors {
    static let primaryGradient = LinearGradient(
        colors: [Color.blue, Color.cyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.98, green: 0.99, blue: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardBackground = Color.white.opacity(0.8)
    static let glassBackground = Color.white.opacity(0.25)
}


