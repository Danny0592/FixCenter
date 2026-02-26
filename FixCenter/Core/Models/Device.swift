//
//  Device.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation

struct Device: Identifiable, Codable, Hashable {
    var id: UUID
    var type: DeviceType
    var brand: String
    var model: String
    var serialNumber: String
    var password: String
    
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
    var displayName: String {
        if brand.isEmpty && model.isEmpty {
            return type.rawValue
        }
        return "\(brand) \(model)".trimmingCharacters(in: .whitespaces)
    }
}


