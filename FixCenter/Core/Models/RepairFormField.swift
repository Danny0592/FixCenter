//
//  RepairFormField.swift
//  FixCenter
//
//  Created by antigravity on 08/03/25.
//

import Foundation

/// Define los campos enfocables en el formulario de reparación.
/// Se utiliza principalmente para gestionar el foco del teclado y el desplazamiento automático (auto-scrolling).
enum RepairFormField: Hashable {
    // MARK: - Sección de Cliente
    /// Campo para el nombre completo del cliente.
    case customerName
    /// Campo para el teléfono del cliente.
    case customerPhone
    /// Campo para la dirección del cliente.
    case customerAddress
    /// Campo para el email del cliente.
    case customerEmail
    
    // MARK: - Sección de Dispositivo
    /// Campo para la marca del dispositivo.
    case deviceBrand
    /// Campo para el modelo del dispositivo.
    case deviceModel
    /// Campo para el número de serie o IMEI.
    case deviceSerial
    /// Campo para la contraseña o patrón del equipo.
    case devicePassword
    
    // MARK: - Sección de Problema
    /// Campo para la descripción de la falla.
    case problemDescription
    
    // MARK: - Sección de Reparación
    /// Campo para el nombre del técnico.
    case technician
    /// Campo para el precio de la reparación.
    case price
    /// Campo para el detalle del trabajo realizado.
    case workPerformed
    /// Campo para notas internas.
    case notes
}
