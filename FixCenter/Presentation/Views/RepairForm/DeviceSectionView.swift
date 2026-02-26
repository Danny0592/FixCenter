//
//  DeviceSectionView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI

struct DeviceSectionView: View {
    @ObservedObject var viewModel: RepairFormViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Selector de tipo de dispositivo
                GlassCard {
                    DeviceTypeSelector(selectedType: $viewModel.repair.device.type)
                }
                
                // Información del dispositivo
                GlassCard {
                    VStack(spacing: 20) {
                        FloatingTextField(
                            title: "Marca",
                            text: $viewModel.repair.device.brand,
                            placeholder: "Ej: Apple, Samsung, HP"
                        )
                        
                        FloatingTextField(
                            title: "Modelo",
                            text: $viewModel.repair.device.model,
                            placeholder: "Ej: iPhone 14, Galaxy S23"
                        )
                        
                        FloatingTextField(
                            title: "Número de serie",
                            text: $viewModel.repair.device.serialNumber,
                            placeholder: "Opcional"
                        )
                        
                        FloatingTextField(
                            title: "Contraseña o código",
                            text: $viewModel.repair.device.password,
                            placeholder: "Para pruebas después de reparación",
                            keyboardType: .namePhonePad
                        )
                    }
                }
            }
            .padding()
        }
        .hideKeyboardOnTap()
    }
}

#Preview {
    DeviceSectionView(
        viewModel: RepairFormViewModel(
            repository: RepairRepositoryImpl(
                storageService: LocalStorageService()
            ),
            imageService: ImageStorageService()
        )
    )
}


