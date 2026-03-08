//
//  RepairFormField.swift
//  FixCenter
//
//  Created by antigravity on 08/03/25.
//

import Foundation

/// Enum representing focusable fields in the repair form for automatic scrolling
enum RepairFormField: Hashable {
    // Customer Section
    case customerName
    case customerPhone
    case customerAddress
    case customerEmail
    
    // Device Section
    case deviceBrand
    case deviceModel
    case deviceSerial
    case devicePassword
    
    // Problem Section
    case problemDescription
    
    // Repair Section
    case technician
    case price
    case workPerformed
    case notes
}
