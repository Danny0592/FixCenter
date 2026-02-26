//
//  DeviceType.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import SwiftUI

enum DeviceType: String, Codable, CaseIterable, Identifiable {
    case phone = "Celular"
    case laptop = "Laptop"
    case desktop = "PC"
    case tablet = "Tablet"
    case console = "Consola"
    case other = "Otro"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .phone:
            return "iphone"
        case .laptop:
            return "laptopcomputer"
        case .desktop:
            return "desktopcomputer"
        case .tablet:
            return "ipad"
        case .console:
            return "gamecontroller"
        case .other:
            return "ellipsis.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .phone:
            return .blue
        case .laptop:
            return .purple
        case .desktop:
            return .indigo
        case .tablet:
            return .cyan
        case .console:
            return .orange
        case .other:
            return .gray
        }
    }
}


