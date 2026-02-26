//
//  RepairStatus.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import SwiftUI

enum RepairStatus: String, Codable, CaseIterable, Identifiable {
    case received = "Recibido"
    case diagnosing = "En Diagnóstico"
    case repairing = "En Reparación"
    case completed = "Completado"
    case delivered = "Entregado"
    case cancelled = "Cancelado"
    
    var id: String { rawValue }
    
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


