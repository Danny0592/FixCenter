//
//  RepairRepositoryImpl.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation

class RepairRepositoryImpl: RepairRepository {
    private let storageService: StorageService
    
    init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    func saveRepair(_ repair: Repair) async throws {
        try await storageService.saveRepair(repair)
    }
    
    func fetchRepairs() async throws -> [Repair] {
        try await storageService.fetchRepairs()
    }
    
    func fetchRepair(id: UUID) async throws -> Repair? {
        try await storageService.fetchRepair(id: id)
    }
    
    func updateRepair(_ repair: Repair) async throws {
        try await storageService.updateRepair(repair)
    }
    
    func deleteRepair(id: UUID) async throws {
        try await storageService.deleteRepair(id: id)
    }
    
    func searchRepairs(query: String) async throws -> [Repair] {
        try await storageService.searchRepairs(query: query)
    }
    
    func filterRepairs(by status: RepairStatus) async throws -> [Repair] {
        try await storageService.filterRepairs(by: status)
    }
}


