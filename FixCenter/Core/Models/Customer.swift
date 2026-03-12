//
//  Customer.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation

/// Representa a un cliente en el sistema de FixCenter.
struct Customer: Identifiable, Codable, Hashable {
    /// Identificador único del cliente.
    var id: UUID
    /// Nombre completo del cliente.
    var fullName: String
    /// Número de teléfono de contacto.
    var phone: String
    /// Dirección física del cliente.
    var address: String
    /// Correo electrónico de contacto.
    var email: String
    
    /// Inicializa un nuevo cliente.
    /// - Parameters:
    ///   - id: Identificador único (por defecto genera uno nuevo).
    ///   - fullName: Nombre completo.
    ///   - phone: Teléfono.
    ///   - address: Dirección.
    ///   - email: Email.
    init(
        id: UUID = UUID(),
        fullName: String = "",
        phone: String = "",
        address: String = "",
        email: String = ""
    ) {
        self.id = id
        self.fullName = fullName
        self.phone = phone
        self.address = address
        self.email = email
    }
}

extension Customer {
    /// Obtiene las iniciales del nombre completo del cliente.
    /// Si el nombre tiene dos o más palabras, toma la primera letra de las dos primeras.
    /// Si tiene una sola palabra, toma las dos primeras letras.
    var initials: String {
        let components = fullName.components(separatedBy: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        } else if !components.isEmpty {
            return String(components[0].prefix(2)).uppercased()
        }
        return "??"
    }
}


