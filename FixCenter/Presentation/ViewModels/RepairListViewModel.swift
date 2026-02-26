//
//  RepairListViewModel.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RepairListViewModel: ObservableObject {
    @Published var repairs: [Repair] = []
    @Published var filteredRepairs: [Repair] = []
    @Published var searchText: String = ""
    @Published var selectedStatus: RepairStatus? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    let repository: RepairRepository
    
    init(repository: RepairRepository) {
        self.repository = repository
    }
    
    func loadRepairs() async {
        isLoading = true
        errorMessage = nil
        
        do {
            repairs = try await repository.fetchRepairs()
            applyFilters()
        } catch {
            errorMessage = "Error al cargar reparaciones: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func deleteRepair(_ repair: Repair) async {
        do {
            try await repository.deleteRepair(id: repair.id)
            await loadRepairs()
        } catch {
            errorMessage = "Error al eliminar reparación: \(error.localizedDescription)"
        }
    }
    
    func searchRepairs() async {
        guard !searchText.isEmpty else {
            applyFilters()
            return
        }
        
        do {
            let results = try await repository.searchRepairs(query: searchText)
            filteredRepairs = results
        } catch {
            errorMessage = "Error en la búsqueda: \(error.localizedDescription)"
        }
    }
    
    func filterByStatus(_ status: RepairStatus?) {
        selectedStatus = status
        applyFilters()
    }
    
    private func applyFilters() {
        var result = repairs
        
        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }
        
        if !searchText.isEmpty {
            let lowerQuery = searchText.lowercased()
            result = result.filter { repair in
                repair.customer.fullName.lowercased().contains(lowerQuery) ||
                repair.device.brand.lowercased().contains(lowerQuery) ||
                repair.device.model.lowercased().contains(lowerQuery)
            }
        }
        
        filteredRepairs = result.sorted { $0.receivedDate > $1.receivedDate }
    }
}

