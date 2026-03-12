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

/// ViewModel que gestiona el flujo de creación y edición de una reparación a través de varios pasos.
/// Controla la navegación entre secciones, la validación de campos y el guardado final.
@MainActor
class RepairFormViewModel: ObservableObject {
    /// Paso actual del formulario (0 a totalSteps-1).
    @Published var currentStep: Int = 0
    /// La reparación que se está creando o editando.
    @Published var repair: Repair = Repair()
    /// Imágenes temporales del estado inicial.
    @Published var initialImages: [UIImage] = []
    /// Imágenes temporales del trabajo finalizado.
    @Published var finalImages: [UIImage] = []
    /// Indica si se está guardando la información.
    @Published var isLoading: Bool = false
    /// Mensaje de error para mostrar en el formulario.
    @Published var errorMessage: String? = nil
    
    /// Repositorio de datos.
    private let repository: RepairRepository
    /// Servicio de procesamiento de imágenes.
    private let imageService: ImageService
    
    /// Número total de secciones del formulario.
    let totalSteps = 4
    /// ID original si estamos editando (nil si es una nueva reparación).
    private var originalRepairId: UUID?
    
    /// Propiedad computada que indica si estamos en modo edición o creación.
    var isEditing: Bool {
        originalRepairId != nil
    }
    
    /// Inicializa el ViewModel, opcionalmente con una reparación existente para editar.
    init(repository: RepairRepository, imageService: ImageService, repair: Repair? = nil) {
        self.repository = repository
        self.imageService = imageService
        if let repair = repair {
            self.repair = repair
            self.originalRepairId = repair.id
            // Cargar imágenes existentes para la interfaz
            self.initialImages = repair.initialPhotos.compactMap { UIImage(data: $0) }
            self.finalImages = repair.finalPhotos.compactMap { UIImage(data: $0) }
        } else {
            self.originalRepairId = nil
        }
    }
    
    /// Indica si se han completado los campos requeridos para avanzar al siguiente paso.
    var canProceedToNextStep: Bool {
        switch currentStep {
        case 0: // Datos del cliente
            return
            !repair.customer.fullName.isEmpty &&
            !repair.customer.phone.isEmpty &&
            !repair.customer.address.isEmpty &&
            !repair.customer.email.isEmpty
        case 1: // Datos del dispositivo
            return
            !repair.device.brand.isEmpty &&
            !repair.device.model.isEmpty &&
            !repair.device.serialNumber.isEmpty &&
            !repair.device.password.isEmpty
        case 2: // Descripción del problema
            return
            !repair.problemDescription.isEmpty
        case 3: // Reparación
            return true
        default:
            return false
        }
    }
    
    /// Avanza al siguiente paso del formulario con animación.
    func nextStep() {
        if currentStep < totalSteps - 1 {
            withAnimation(.spring()) {
                currentStep += 1
            }
        }
    }
    
    /// Retrocede al paso anterior con animación.
    func previousStep() {
        if currentStep > 0 {
            withAnimation(.spring()) {
                currentStep -= 1
            }
        }
    }
    
    /// Procesa las imágenes y guarda la reparación en el repositorio.
    func saveRepair() async {
        isLoading = true
        errorMessage = nil
        
        do {
            var repairToSave = repair
            
            // Generar folio solo para nuevas reparaciones
            if !isEditing {
                repairToSave.folio = try await generateNextFolio()
            }
            
            // Procesar y comprimir imágenes (iniciales y finales)
            repairToSave.initialPhotos = try await processImages(initialImages)
            repairToSave.finalPhotos = try await processImages(finalImages)
            
            // Persistir cambios
            try await repository.saveRepair(repairToSave)
        } catch {
            errorMessage = "Error al guardar reparación: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// Genera automáticamente el siguiente folio basado en el año actual (ej. OS-2024-0001).
    private func generateNextFolio() async throws -> String {
        let repairs = try await repository.fetchRepairs()
        let year = Calendar.current.component(.year, from: Date())
        let prefix = "OS-\(year)-"
        
        let numbersInYear = repairs.compactMap { repair -> Int? in
            guard let folio = repair.folio, folio.hasPrefix(prefix) else { return nil }
            let suffix = String(folio.dropFirst(prefix.count))
            return Int(suffix)
        }
        
        let nextNumber = (numbersInYear.max() ?? 0) + 1
        return "\(prefix)\(String(format: "%04d", nextNumber))"
    }
    
    /// Comprime un set de imágenes utilizando el servicio de imágenes.
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

