//
//  StorageService.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation

protocol StorageService {
    func saveRepair(_ repair: Repair) async throws
    func fetchRepairs() async throws -> [Repair]
    func fetchRepair(id: UUID) async throws -> Repair?
    func updateRepair(_ repair: Repair) async throws
    func deleteRepair(id: UUID) async throws
    func searchRepairs(query: String) async throws -> [Repair]
    func filterRepairs(by status: RepairStatus) async throws -> [Repair]
}


