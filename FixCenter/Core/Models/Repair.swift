//
//  Repair.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation

struct Repair: Identifiable, Codable, Hashable {
    var id: UUID
    var folio: String?
    var customer: Customer
    var device: Device
    var problemDescription: String
    var status: RepairStatus
    var receivedDate: Date
    var deliveryDate: Date?
    var initialPhotos: [Data]
    var finalPhotos: [Data]
    var workPerformed: String
    var notes: String
    var price: Double?
    
    init(
        id: UUID = UUID(),
        folio: String? = nil,
        customer: Customer = Customer(),
        device: Device = Device(),
        problemDescription: String = "",
        status: RepairStatus = .received,
        receivedDate: Date = Date(),
        deliveryDate: Date? = nil,
        initialPhotos: [Data] = [],
        finalPhotos: [Data] = [],
        workPerformed: String = "",
        notes: String = "",
        price: Double? = nil
    ) {
        self.id = id
        self.folio = folio
        self.customer = customer
        self.device = device
        self.problemDescription = problemDescription
        self.status = status
        self.receivedDate = receivedDate
        self.deliveryDate = deliveryDate
        self.initialPhotos = initialPhotos
        self.finalPhotos = finalPhotos
        self.workPerformed = workPerformed
        self.notes = notes
        self.price = price
    }
}

extension Repair {
    var daysInRepair: Int {
        Calendar.current.dateComponents([.day], from: receivedDate, to: Date()).day ?? 0
    }
    
    var isOverdue: Bool {
        daysInRepair > 7 && status != .delivered && status != .cancelled
    }
    
    var formattedPrice: String {
        guard let price = price else { return "No especificado" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: NSNumber(value: price)) ?? "$\(String(format: "%.2f", price))"
    }
}


