//
//  ProblemSectionView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
// TODO: Vista de descripcion del problema
struct ProblemSectionView: View {
    @ObservedObject var viewModel: RepairFormViewModel
    @FocusState private var isProblemDescriptionFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Descripción del problema")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextEditor(text: $viewModel.repair.problemDescription)
                            .frame(minHeight: 150)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.8))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .focused($isProblemDescriptionFocused)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Listo") {
                                        isProblemDescriptionFocused = false
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                    }
                }
                
                GlassCard {
                    ImagePickerView(
                        selectedImages: $viewModel.initialImages,
                        title: "Fotos del daño inicial",
                        maxImages: 10
                    )
                }
            }
            .padding()
            .padding(.bottom, 100)
        }
        .hideKeyboardOnTap()
    }
}

#Preview {
    ProblemSectionView(
        viewModel: RepairFormViewModel(
            repository: RepairRepositoryImpl(
                storageService: LocalStorageService()
            ),
            imageService: ImageStorageService()
        )
    )
}


