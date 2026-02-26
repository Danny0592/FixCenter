//
//  LocalStorageService.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation

class LocalStorageService: StorageService {
    private let repairsKey = "saved_repairs"
    
    func saveRepair(_ repair: Repair) async throws {
        var repairs = try await fetchRepairs()
        if let index = repairs.firstIndex(where: { $0.id == repair.id }) {
            repairs[index] = repair
        } else {
            repairs.append(repair)
        }
        try saveRepairs(repairs)
    }
    
    func fetchRepairs() async throws -> [Repair] {
        guard let data = UserDefaults.standard.data(forKey: repairsKey) else {
            return []
        }
        return try JSONDecoder().decode([Repair].self, from: data)
    }
    
    func fetchRepair(id: UUID) async throws -> Repair? {
        let repairs = try await fetchRepairs()
        return repairs.first { $0.id == id }
    }
    
    func updateRepair(_ repair: Repair) async throws {
        try await saveRepair(repair)
    }
    
    func deleteRepair(id: UUID) async throws {
        var repairs = try await fetchRepairs()
        repairs.removeAll { $0.id == id }
        try saveRepairs(repairs)
    }
    
    func searchRepairs(query: String) async throws -> [Repair] {
        let repairs = try await fetchRepairs()
        let lowerQuery = query.lowercased()
        return repairs.filter { repair in
            repair.customer.fullName.lowercased().contains(lowerQuery) ||
            repair.device.brand.lowercased().contains(lowerQuery) ||
            repair.device.model.lowercased().contains(lowerQuery) ||
            repair.problemDescription.lowercased().contains(lowerQuery)
        }
    }
    
    func filterRepairs(by status: RepairStatus) async throws -> [Repair] {
        let repairs = try await fetchRepairs()
        return repairs.filter { $0.status == status }
    }
    
    private func saveRepairs(_ repairs: [Repair]) throws {
        let data = try JSONEncoder().encode(repairs)
        UserDefaults.standard.set(data, forKey: repairsKey)
    }
}


