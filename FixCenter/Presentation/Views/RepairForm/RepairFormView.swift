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
                
                // Contenido del formulario
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
                
                // Botones de navegación
                navigationButtons
                
                // Mensaje de error si falla el guardado
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
        
        return HStack(spacing: hasThreeButtons ? 8 : 16) {
            if viewModel.currentStep > 0 {
                Button(action: {
                    viewModel.previousStep()
                }) {
                    if hasThreeButtons {
                        // Botón compacto cuando hay 3 botones
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                            )
                    } else {
                        // Botón normal cuando hay menos botones
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Anterior")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.1))
                        )
                    }
                }
            }
            
            // Si está en modo edición, mostrar botón de guardar en todos los pasos
            if viewModel.isEditing {
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
                
                // Si no es el último paso, también mostrar "Siguiente"
                if viewModel.currentStep < viewModel.totalSteps - 1 {
                    GradientButton(
                        title: "Siguiente",
                        action: {
                            viewModel.nextStep()
                        },
                        icon: "chevron.right",
                        isCompact: hasThreeButtons
                    )
                    .disabled(!viewModel.canProceedToNextStep)
                    .opacity(viewModel.canProceedToNextStep ? 1 : 0.5)
                }
            } else {
                // Modo creación: comportamiento original
                if viewModel.currentStep < viewModel.totalSteps - 1 {
                    GradientButton(
                        title: "Siguiente",
                        action: {
                            viewModel.nextStep()
                        },
                        icon: "chevron.right"
                    )
                    .disabled(!viewModel.canProceedToNextStep)
                    .opacity(viewModel.canProceedToNextStep ? 1 : 0.5)
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
                        icon: "checkmark",
                        isLoading: viewModel.isLoading
                    )
                }
            }
        }
        .padding(hasThreeButtons ? .horizontal : [])
        .padding(.vertical)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
        )
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

