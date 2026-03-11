//
//  RepairStatus.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import SwiftUI

/// Representa los posibles estados de una orden de reparación en el taller.
enum RepairStatus: String, Codable, CaseIterable, Identifiable {
    /// El equipo ha sido recibido pero no se ha iniciado el diagnóstico.
    case received = "Recibido"
    /// El equipo está siendo revisado para identificar la falla.
    case diagnosing = "En Diagnóstico"
    /// Se está realizando la reparación física o de software.
    case repairing = "En Reparación"
    /// La reparación se ha terminado con éxito.
    case completed = "Completado"
    /// El equipo ha sido devuelto al cliente.
    case delivered = "Entregado"
    /// La orden de reparación ha sido invalidada o rechazada.
    case cancelled = "Cancelado"
    
    /// Identificador único (rawValue).
    var id: String { rawValue }
    
    /// Color distintivo del estado para la interfaz de usuario.
    var color: Color {
        switch self {
        case .received:
            return .blue
        case .diagnosing:
            return .orange
        case .repairing:
            return .purple
        case .completed:
            return .green
        case .delivered:
            return .mint
        case .cancelled:
            return .red
        }
    }
    
    /// Icono descriptivo (SF Symbols) asociado al estado.
    var icon: String {
        switch self {
        case .received:
            return "tray.and.arrow.down"
        case .diagnosing:
            return "magnifyingglass"
        case .repairing:
            return "wrench.and.screwdriver"
        case .completed:
            return "checkmark.circle.fill"
        case .delivered:
            return "shippingbox.fill"
        case .cancelled:
            return "xmark.circle.fill"
        }
    }
    
    /// Degradado visual para tarjetas y elementos destacados.
    var gradient: LinearGradient {
        switch self {
        case .received:
            return LinearGradient(
                colors: [.blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .diagnosing:
            return LinearGradient(
                colors: [.orange, .yellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .repairing:
            return LinearGradient(
                colors: [.purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .completed:
            return LinearGradient(
                colors: [.green, .mint],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .delivered:
            return LinearGradient(
                colors: [.mint, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .cancelled:
            return LinearGradient(
                colors: [.red, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}


