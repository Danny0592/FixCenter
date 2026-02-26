//
//  Customer.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation

struct Customer: Identifiable, Codable, Hashable {
    var id: UUID
    var fullName: String
    var phone: String
    var address: String
    var email: String
    
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


