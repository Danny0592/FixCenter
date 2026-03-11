//
//  RepairDetailViewModel.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import SwiftUI
import UIKit
import Combine

/// ViewModel que gestiona la lógica de visualización y modificación de una reparación específica.
/// Maneja la conversión de imágenes, actualización de estados y persistencia de cambios.
@MainActor
class RepairDetailViewModel: ObservableObject {
    /// La reparación que se está visualizando.
    @Published var repair: Repair
    /// Indica si se está realizando una operación asíncrona.
    @Published var isLoading: Bool = false
    /// Mensaje de error en caso de fallos.
    @Published var errorMessage: String? = nil
    /// Imágenes de la recepción del equipo.
    @Published var initialImageUIs: [UIImage] = []
    /// Imágenes del resultado final de la reparación.
    @Published var finalImageUIs: [UIImage] = []
    
    /// Repositorio de acceso a datos.
    let repository: RepairRepository
    /// Servicio para el procesamiento de imágenes.
    private let imageService: ImageService = ImageStorageService()
    
    /// Inicializa el ViewModel cargando los datos y convirtiendo las fotos.
    /// - Parameters:
    ///   - repair: La reparación a mostrar.
    ///   - repository: El repositorio para guardar cambios.
    init(repair: Repair, repository: RepairRepository) {
        self.repair = repair
        self.repository = repository
        loadImages()
    }
    
    /// Convierte los arrays de `Data` de la reparación en objetos `UIImage` para la interfaz.
    func loadImages() {
        initialImageUIs = repair.initialPhotos.compactMap { UIImage(data: $0) }
        finalImageUIs = repair.finalPhotos.compactMap { UIImage(data: $0) }
    }
    
    /// Actualiza el estado de la reparación y guarda el cambio inmediatamente.
    /// - Parameter status: El nuevo estado.
    func updateStatus(_ status: RepairStatus) async {
        repair.status = status
        if status == .delivered {
            repair.deliveryDate = Date()
        }
        
        do {
            try await repository.updateRepair(repair)
        } catch {
            errorMessage = "Error al actualizar estado: \(error.localizedDescription)"
        }
    }
    
    /// Sincroniza las imágenes de la interfaz con el modelo y guarda todos los cambios en el repositorio.
    func saveChanges() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Convertir imágenes UI a Data si se modificaron
            if !initialImageUIs.isEmpty {
                repair.initialPhotos = initialImageUIs.compactMap { image in
                    image.jpegData(compressionQuality: 0.8)
                }
            }
            
            if !finalImageUIs.isEmpty {
                repair.finalPhotos = finalImageUIs.compactMap { image in
                    imageService.compressImage(image, maxSizeKB: 500) ?? image.jpegData(compressionQuality: 0.8)
                }
            }
            
            try await repository.updateRepair(repair)
        } catch {
            errorMessage = "Error al guardar cambios: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// Elimina la reparación actual del repositorio.
    func deleteRepair() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await repository.deleteRepair(id: repair.id)
        } catch {
            errorMessage = "Error al eliminar reparación: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

