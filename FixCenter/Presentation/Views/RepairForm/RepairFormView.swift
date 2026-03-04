//
//  RepairFormView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI

struct RepairFormView: View {
    @ObservedObject var viewModel: RepairFormViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showSaveConfirmation = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Indicador de progreso
                progressIndicator
                
                // Contenido del formulario + Botones flotantes
                ZStack(alignment: .bottom) {
                    TabView(selection: $viewModel.currentStep) {
                        CustomerSectionView(viewModel: viewModel)
                            .tag(0)
                        
                        DeviceSectionView(viewModel: viewModel)
                            .tag(1)
                        
                        ProblemSectionView(viewModel: viewModel)
                            .tag(2)
                        
                        RepairSectionView(viewModel: viewModel)
                            .tag(3)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .ignoresSafeArea(edges: .bottom)
                    
                    // Barra de navegación flotante
                    VStack(spacing: 8) {
                        navigationButtons
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.bottom, 8)
                                .padding(.horizontal)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.isEditing ? "Editar Reparación" : "Nueva Reparación")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reparación guardada", isPresented: $showSaveConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("La reparación se ha guardado exitosamente")
        }
    }
    
    private var progressIndicator: some View {
        VStack(spacing: 12) {
            HStack {
                ForEach(0..<viewModel.totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= viewModel.currentStep ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 12, height: 12)
                        .animation(.spring(), value: viewModel.currentStep)
                }
            }
            
            Text(stepTitle)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
        )
    }
    
    private var stepTitle: String {
        switch viewModel.currentStep {
        case 0: return "Datos del Cliente"
        case 1: return "Datos del Dispositivo"
        case 2: return "Descripción del Problema"
        case 3: return "Reparación y Evidencia"
        default: return ""
        }
    }
    
    private var navigationButtons: some View {
        let hasThreeButtons = viewModel.isEditing && 
                             viewModel.currentStep > 0 && 
                             viewModel.currentStep < viewModel.totalSteps - 1
        
        return HStack(spacing: hasThreeButtons ? 12 : 26) {
            if viewModel.currentStep > 0 {
                GradientButton(
                    title: "Anterior",
                    action: {
                        viewModel.previousStep()
                    },
                    icon: "chevron.left",
                    isCompact: hasThreeButtons
                )
            }
            
            if viewModel.isEditing {
                // Botón Guardar siempre presente en edición
                GradientButton(
                    title: "Guardar",
                    action: {
                        Task {
                            await viewModel.saveRepair()
                            if viewModel.errorMessage == nil {
                                showSaveConfirmation = true
                            }
                        }
                    },
                    icon: "checkmark",
                    isLoading: viewModel.isLoading,
                    isCompact: hasThreeButtons
                )
                
                if viewModel.currentStep < viewModel.totalSteps - 1 {
                    // Botón Siguiente si no es el final
                    GradientButton(
                        title: "Siguiente",
                        action: {
                            viewModel.nextStep()
                        },
                        icon: "chevron.right",
                        isCompact: hasThreeButtons
                    )
                    .disabled(!viewModel.canProceedToNextStep)
                    .opacity(viewModel.canProceedToNextStep ? 1 : 0.6)
                }
            } else {
                // Modo creación: comportamiento original pero con diseño mejorado
                if viewModel.currentStep < viewModel.totalSteps - 1 {
                    GradientButton(
                        title: "Siguiente",
                        action: {
                            viewModel.nextStep()
                        },
                        icon: "chevron.right"
                    )
                    .disabled(!viewModel.canProceedToNextStep)
                    .opacity(viewModel.canProceedToNextStep ? 1 : 0.6)
                } else {
                    GradientButton(
                        title: "Guardar",
                        action: {
                            Task {
                                await viewModel.saveRepair()
                                if viewModel.errorMessage == nil {
                                    showSaveConfirmation = true
                                }
                            }
                        },
                        icon: "checkmark.circle.fill",
                        isLoading: viewModel.isLoading
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack {
                Capsule()
                    .fill(.ultraThinMaterial)
                Capsule()
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .padding(.bottom, 12)
        .animation(.snappy(duration: 0.3), value: viewModel.currentStep)
    }
}

#Preview {
    NavigationStack {
        RepairFormView(
            viewModel: RepairFormViewModel(
                repository: RepairRepositoryImpl(
                    storageService: LocalStorageService()
                ),
                imageService: ImageStorageService()
            )
        )
    }
}

