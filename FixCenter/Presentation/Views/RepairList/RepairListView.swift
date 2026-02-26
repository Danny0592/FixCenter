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
    
    init(viewModel: RepairListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con gradiente
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Header con búsqueda
                        searchSection
                        
                        // Filtros rápidos
                        filterSection
                        
                        // Lista de reparaciones
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 50)
                        } else if viewModel.filteredRepairs.isEmpty {
                            emptyStateView
                        } else {
                            repairsList
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .refreshable {
                    await viewModel.loadRepairs()
                }
            }
            .navigationTitle("FixCenter")
            .navigationBarTitleDisplayMode(.large)
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
                .onChange(of: viewModel.searchText) { _ in
                    Task {
                        await viewModel.searchRepairs()
                    }
                }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
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
    
    private var repairsList: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.filteredRepairs) { repair in
                RepairCard(repair: repair) {
                    selectedRepair = repair
                }
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
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No hay reparaciones")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text("Toca el botón + para agregar una nueva reparación")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 100)
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

