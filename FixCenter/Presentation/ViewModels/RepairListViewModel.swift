//
//  RepairListViewModel.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel que gestiona la lógica de negocio para la lista de reparaciones.
/// Se encarga de la carga, búsqueda, filtrado y eliminación de servicios.
@MainActor
class RepairListViewModel: ObservableObject {
    /// Lista completa de reparaciones cargadas.
    @Published var repairs: [Repair] = []
    /// Lista filtrada que se muestra actualmente en la interfaz.
    @Published var filteredRepairs: [Repair] = []
    /// Texto de búsqueda actual.
    @Published var searchText: String = ""
    /// Estado seleccionado para filtrar la lista.
    @Published var selectedStatus: RepairStatus? = nil
    /// Indica si se están cargando datos.
    @Published var isLoading: Bool = false
    /// Mensaje de error en caso de fallo en alguna operación.
    @Published var errorMessage: String? = nil
    
    /// Repositorio para el acceso a datos de reparaciones.
    let repository: RepairRepository
    
    /// Inicializa el ViewModel con su repositorio.
    init(repository: RepairRepository) {
        self.repository = repository
    }
    
    /// Carga todas las reparaciones desde el repositorio.
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
    
    /// Elimina una reparación específica.
    /// - Parameter repair: La reparación a eliminar.
    func deleteRepair(_ repair: Repair) async {
        do {
            try await repository.deleteRepair(id: repair.id)
            await loadRepairs()
        } catch {
            errorMessage = "Error al eliminar reparación: \(error.localizedDescription)"
        }
    }
    
    /// Realiza una búsqueda de reparaciones basada en el texto ingresado.
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
    
    /// Filtra la lista por un estado específico.
    /// - Parameter status: El estado por el cual filtrar (o nil para mostrar todos).
    func filterByStatus(_ status: RepairStatus?) {
        selectedStatus = status
        applyFilters()
    }
    
    /// Aplica los filtros de búsqueda y estado sobre la lista base de reparaciones.
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

