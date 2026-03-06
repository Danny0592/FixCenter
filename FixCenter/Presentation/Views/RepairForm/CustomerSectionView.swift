//
//  CustomerSectionView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
// TODO: Vista datos del cliente
struct CustomerSectionView: View {
    @ObservedObject var viewModel: RepairFormViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                GlassCard {
                    VStack(spacing: 20) {
                        FloatingTextField(
                            title: "Nombre completo",
                            text: $viewModel.repair.customer.fullName,
                            placeholder: "Ej: Juan Pérez"
                        )
                        
                        FloatingTextField(
                            title: "Teléfono",
                            text: $viewModel.repair.customer.phone,
                            placeholder: "Ej: +52 123 456 7890",
                            keyboardType: .phonePad
                        )
                        
                        FloatingTextField(
                            title: "Dirección",
                            text: $viewModel.repair.customer.address,
                            placeholder: "Ej: Calle Principal 123"
                        )
                        
                        FloatingTextField(
                            title: "Correo electrónico",
                            text: $viewModel.repair.customer.email,
                            placeholder: "Ej: juan@example.com",
                            keyboardType: .emailAddress
                        )
                    }
                }
            }
            .padding()
            .padding(.bottom, 100)
        }
        .hideKeyboardOnTap()
    }
}

#Preview {
    CustomerSectionView(
        viewModel: RepairFormViewModel(
            repository: RepairRepositoryImpl(
                storageService: LocalStorageService()
            ),
            imageService: ImageStorageService()
        )
    )
}


