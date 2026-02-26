//
//  RepairFormViewModel.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import SwiftUI
import UIKit
import Combine

@MainActor
class RepairFormViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var repair: Repair = Repair()
    @Published var initialImages: [UIImage] = []
    @Published var finalImages: [UIImage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let repository: RepairRepository
    private let imageService: ImageService
    
    let totalSteps = 4
    private var originalRepairId: UUID?
    
    var isEditing: Bool {
        originalRepairId != nil
    }
    
    init(repository: RepairRepository, imageService: ImageService, repair: Repair? = nil) {
        self.repository = repository
        self.imageService = imageService
        if let repair = repair {
            self.repair = repair
            self.originalRepairId = repair.id
            // Cargar imágenes existentes
            self.initialImages = repair.initialPhotos.compactMap { UIImage(data: $0) }
            self.finalImages = repair.finalPhotos.compactMap { UIImage(data: $0) }
        } else {
            self.originalRepairId = nil
        }
    }
    
    var canProceedToNextStep: Bool {
        switch currentStep {
        case 0: // Datos del cliente
            return !repair.customer.fullName.isEmpty &&
                   !repair.customer.phone.isEmpty
        case 1: // Datos del dispositivo
            return !repair.device.brand.isEmpty &&
                   !repair.device.model.isEmpty
        case 2: // Descripción del problema
            return !repair.problemDescription.isEmpty
        case 3: // Reparación
            return true
        default:
            return false
        }
    }
    
    func nextStep() {
        if currentStep < totalSteps - 1 {
            withAnimation(.spring()) {
                currentStep += 1
            }
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            withAnimation(.spring()) {
                currentStep -= 1
            }
        }
    }
    
    func saveRepair() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Comprimir y convertir imágenes
            var repairToSave = repair
            
            // Procesar imágenes iniciales
            repairToSave.initialPhotos = try await processImages(initialImages)
            
            // Procesar imágenes finales
            repairToSave.finalPhotos = try await processImages(finalImages)
            
            // Guardar reparación
            try await repository.saveRepair(repairToSave)
        } catch {
            errorMessage = "Error al guardar reparación: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func processImages(_ images: [UIImage]) async throws -> [Data] {
        var imageData: [Data] = []
        
        for image in images {
            if let compressed = imageService.compressImage(image, maxSizeKB: 500) {
                imageData.append(compressed)
            }
        }
        
        return imageData
    }
}

