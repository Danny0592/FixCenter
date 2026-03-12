//
//  Device.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation

/// Representa el dispositivo que requiere reparación.
struct Device: Identifiable, Codable, Hashable {
    /// Identificador único del dispositivo.
    var id: UUID
    /// Tipo de dispositivo (ej. Teléfono, Tablet, etc.).
    var type: DeviceType
    /// Marca del fabricante.
    var brand: String
    /// Modelo específico del dispositivo.
    var model: String
    /// Número de serie o IMEI.
    var serialNumber: String
    /// Contraseña o patrón de desbloqueo para pruebas.
    var password: String
    
    /// Inicializa un nuevo dispositivo.
    /// - Parameters:
    ///   - id: Identificador único.
    ///   - type: Tipo de dispositivo.
    ///   - brand: Marca.
    ///   - model: Modelo.
    ///   - serialNumber: Número de serie.
    ///   - password: Contraseña.
    init(
        id: UUID = UUID(),
        type: DeviceType = .phone,
        brand: String = "",
        model: String = "",
        serialNumber: String = "",
        password: String = ""
    ) {
        self.id = id
        self.type = type
        self.brand = brand
        self.model = model
        self.serialNumber = serialNumber
        self.password = password
    }
}

extension Device {
    /// Nombre formateado para mostrar (Marca + Modelo).
    /// Si ambos están vacíos, muestra el tipo de dispositivo.
    var displayName: String {
        if brand.isEmpty && model.isEmpty {
            return type.rawValue
        }
        return "\(brand) \(model)".trimmingCharacters(in: .whitespaces)
    }
}


