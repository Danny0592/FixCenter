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

@MainActor
class RepairDetailViewModel: ObservableObject {
    @Published var repair: Repair
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var initialImageUIs: [UIImage] = []
    @Published var finalImageUIs: [UIImage] = []
    
    let repository: RepairRepository
    private let imageService: ImageService = ImageStorageService() // For compression if needed
    
    init(repair: Repair, repository: RepairRepository) {
        self.repair = repair
        self.repository = repository
        loadImages()
    }
    
    func loadImages() {
        initialImageUIs = repair.initialPhotos.compactMap { UIImage(data: $0) }
        finalImageUIs = repair.finalPhotos.compactMap { UIImage(data: $0) }
    }
    
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

