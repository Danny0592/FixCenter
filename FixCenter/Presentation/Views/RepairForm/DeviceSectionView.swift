//
//  DeviceSectionView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
/// Vista de informacion del dispositivo
struct DeviceSectionView: View {
    @ObservedObject var viewModel: RepairFormViewModel
    @FocusState private var focusedField: RepairFormField?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 24) {
                    Color.clear
                        .frame(height: 1)
                        .id("top")
                    
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
                                placeholder: "Ej: Apple, Samsung, HP",
                                focusState: $focusedField,
                                focusValue: .deviceBrand
                            )
                            .id(RepairFormField.deviceBrand)
                            
                            FloatingTextField(
                                title: "Modelo",
                                text: $viewModel.repair.device.model,
                                placeholder: "Ej: iPhone 14, Galaxy S23",
                                focusState: $focusedField,
                                focusValue: .deviceModel
                            )
                            .id(RepairFormField.deviceModel)
                            
                            FloatingTextField(
                                title: "Número de serie",
                                text: $viewModel.repair.device.serialNumber,
                                placeholder: "Opcional",
                                focusState: $focusedField,
                                focusValue: .deviceSerial
                            )
                            .id(RepairFormField.deviceSerial)
                            
                            FloatingTextField(
                                title: "Contraseña o código",
                                text: $viewModel.repair.device.password,
                                placeholder: "Para pruebas después de reparación",
                                keyboardType: .namePhonePad,
                                focusState: $focusedField,
                                focusValue: .devicePassword
                            )
                            .id(RepairFormField.devicePassword)
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .hideKeyboardOnTap()
            .onChange(of: focusedField) { newValue in
                if let field = newValue {
                    withAnimation(.spring()) {
                        proxy.scrollTo(field, anchor: UnitPoint(x: 0.5, y: 0.8))
                    }
                }
            }
        }
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


