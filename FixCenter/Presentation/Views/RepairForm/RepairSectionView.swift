//
//  RepairSectionView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI

struct RepairSectionView: View {
    @ObservedObject var viewModel: RepairFormViewModel
    @FocusState private var isWorkPerformedFocused: Bool
    @FocusState private var isNotesFocused: Bool
    @FocusState private var isPriceFocused: Bool
    @State private var priceText: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Precio de la reparación")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Text("$")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            TextField("0.00", text: $priceText)
                                .keyboardType(.decimalPad)
                                .font(.title2)
                                .focused($isPriceFocused)
                                .onChange(of: priceText) { newValue in
                                    if let price = Double(newValue) {
                                        viewModel.repair.price = price
                                    } else if newValue.isEmpty {
                                        viewModel.repair.price = nil
                                    }
                                }
                                .onAppear {
                                    if let price = viewModel.repair.price {
                                        priceText = String(format: "%.2f", price)
                                    }
                                }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.8))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Listo") {
                                    isPriceFocused = false
                                }
                                .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                GlassCard {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Trabajo realizado")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextEditor(text: $viewModel.repair.workPerformed)
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
                            .focused($isWorkPerformedFocused)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Listo") {
                                        isWorkPerformedFocused = false
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                    }
                }
                
                GlassCard {
                    ImagePickerView(
                        selectedImages: $viewModel.finalImages,
                        title: "Fotos del dispositivo reparado",
                        maxImages: 10
                    )
                }
                
                GlassCard {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Notas adicionales")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextEditor(text: $viewModel.repair.notes)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.8))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .focused($isNotesFocused)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Listo") {
                                        isNotesFocused = false
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                    }
                }
            }
            .padding()
        }
        .hideKeyboardOnTap()
    }
}

#Preview {
    RepairSectionView(
        viewModel: RepairFormViewModel(
            repository: RepairRepositoryImpl(
                storageService: LocalStorageService()
            ),
            imageService: ImageStorageService()
        )
    )
}


