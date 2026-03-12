//
//  Constants.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import SwiftUI

/// Valores numéricos constantes utilizados para mantener la consistencia visual en toda la app.
enum AppConstants {
    /// Radio de esquina estándar para tarjetas y botones (16pt).
    static let cornerRadius: CGFloat = 16
    /// Padding estándar dentro de las tarjetas (16pt).
    static let cardPadding: CGFloat = 16
    /// Duración base para las animaciones de la interfaz (0.3s).
    static let animationDuration: Double = 0.3
    /// Radio de desenfoque utilizado para efectos de cristal (20pt).
    static let blurRadius: CGFloat = 20
}

/// Definición de la paleta de colores y degradados globales de FixCenter.
enum AppColors {
    /// Degradado principal de la aplicación (Azul a Cian).
    static let primaryGradient = LinearGradient(
        colors: [Color.blue, Color.cyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Degradado sutil utilizado como fondo de las vistas principales.
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.98, green: 0.99, blue: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    /// Color de fondo para las tarjetas con opacidad del 80%.
    static let cardBackground = Color.white.opacity(0.8)
    /// Color de fondo para el efecto de cristal (opacidad del 25%).
    static let glassBackground = Color.white.opacity(0.25)
}


