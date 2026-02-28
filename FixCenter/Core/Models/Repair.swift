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
    var assignedTechnician: String
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
        assignedTechnician: String = "",
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
        self.assignedTechnician = assignedTechnician
        self.status = status
        self.receivedDate = receivedDate
        self.deliveryDate = deliveryDate
        self.initialPhotos = initialPhotos
        self.finalPhotos = finalPhotos
        self.workPerformed = workPerformed
        self.notes = notes
        self.price = price
    }
    
    enum CodingKeys: String, CodingKey {
        case id, folio, customer, device, problemDescription, assignedTechnician, status, receivedDate, deliveryDate, initialPhotos, finalPhotos, workPerformed, notes, price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        folio = try container.decodeIfPresent(String.self, forKey: .folio)
        customer = try container.decode(Customer.self, forKey: .customer)
        device = try container.decode(Device.self, forKey: .device)
        problemDescription = try container.decode(String.self, forKey: .problemDescription)
        assignedTechnician = try container.decodeIfPresent(String.self, forKey: .assignedTechnician) ?? ""
        status = try container.decode(RepairStatus.self, forKey: .status)
        receivedDate = try container.decode(Date.self, forKey: .receivedDate)
        deliveryDate = try container.decodeIfPresent(Date.self, forKey: .deliveryDate)
        initialPhotos = try container.decode([Data].self, forKey: .initialPhotos)
        finalPhotos = try container.decode([Data].self, forKey: .finalPhotos)
        workPerformed = try container.decode(String.self, forKey: .workPerformed)
        notes = try container.decode(String.self, forKey: .notes)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
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


