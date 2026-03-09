//
//  RepairListView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI

struct RepairListView: View {
    @StateObject private var viewModel: RepairListViewModel
    @State private var showNewRepair = false
    @State private var selectedRepair: Repair? = nil
    @FocusState private var isSearchFocused: Bool
    
    init(viewModel: RepairListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header con búsqueda y filtros (fijos arriba)
                VStack(spacing: 16) {
                    searchSection
                    filterSection
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Lista de reparaciones
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredRepairs.isEmpty {
                    emptyStateView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.filteredRepairs) { repair in
                            RepairCard(repair: repair) {
                                selectedRepair = repair
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteRepair(repair)
                                    }
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.loadRepairs()
                    }
                }
            }
            .background(AppColors.backgroundGradient.ignoresSafeArea())
            .navigationTitle("FixCenter")
//            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewRepair = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showNewRepair) {
                NavigationStack {
                    RepairFormView(
                        viewModel: RepairFormViewModel(
                            repository: viewModel.repository,
                            imageService: ImageStorageService()
                        )
                    )
                }
                .onDisappear {
                    // Recargar la lista cuando se cierra el formulario
                    Task {
                        await viewModel.loadRepairs()
                    }
                }
            }
            .sheet(item: $selectedRepair) { repair in
                NavigationStack {
                    RepairDetailView(
                        viewModel: RepairDetailViewModel(
                            repair: repair,
                            repository: viewModel.repository
                        )
                    )
                }
                .onDisappear {
                    // Recargar la lista cuando se cierra el detalle (por si se actualizó el estado)
                    Task {
                        await viewModel.loadRepairs()
                    }
                }
            }
            .task {
                await viewModel.loadRepairs()
            }
        }
    }
    
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar reparaciones...", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isSearchFocused)
                .onChange(of: viewModel.searchText) { _ in
                    Task {
                        await viewModel.searchRepairs()
                    }
                }
            
            if !viewModel.searchText.isEmpty && isSearchFocused {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "Todos",
                    isSelected: viewModel.selectedStatus == nil
                ) {
                    viewModel.filterByStatus(nil)
                }
                
                ForEach(RepairStatus.allCases) { status in
                    FilterChip(
                        title: status.rawValue,
                        isSelected: viewModel.selectedStatus == status,
                        color: status.color
                    ) {
                        viewModel.filterByStatus(status)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private var emptyStateView: some View {
        let title: String
        let message: String
        let icon: String
        
        if let status = viewModel.selectedStatus {
            icon = status.icon
            let statusText: String
            switch status {
            case .diagnosing, .repairing:
                statusText = status.rawValue.lowercased()
            default:
                statusText = "\(status.rawValue.lowercased())s"
            }
            title = "No hay servicios \(statusText)"
            message = "Actualmente no tienes ninguna reparación en este estado"
        } else if !viewModel.searchText.isEmpty {
            icon = "magnifyingglass"
            title = "Sin resultados"
            message = "No encontramos reparaciones que coincidan con \"\(viewModel.searchText)\""
        } else {
            icon = "wrench.and.screwdriver"
            title = "No hay reparaciones"
            message = "Toca el botón + para agregar una nueva reparación"
        }
        
        return VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 100)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = .blue
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? color : color.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    RepairListView(
        viewModel: RepairListViewModel(
            repository: RepairRepositoryImpl(
                storageService: LocalStorageService()
            )
        )
    )
}

