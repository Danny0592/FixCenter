//
//  RepairDetailView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI

struct RepairDetailView: View {
    @ObservedObject var viewModel: RepairDetailViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showStatusPicker = false
    @State private var showImageFullscreen = false
    @State private var selectedImageIndex = 0
    @State private var isShowingInitial = true
    @State private var showEditView = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header con información principal
                headerSection
                
                // Información del cliente
                customerSection
                
                // Información del dispositivo
                deviceSection
                
                // Estado y timeline
                statusSection
                
                // Descripción del problema
                problemSection
                
                // Precio
                if viewModel.repair.price != nil {
                    priceSection
                }
                
                // Trabajo realizado
                workSection
                
                // Botón de eliminar
                deleteButton
                
                // Galería de imágenes
                if !viewModel.initialImageUIs.isEmpty || !viewModel.finalImageUIs.isEmpty {
                    imageGallerySection
                }
            }
            .padding()
        }
        .background(AppColors.backgroundGradient.ignoresSafeArea())
        .navigationTitle("Detalle de Reparación")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showEditView = true
                }) {
                    Image(systemName: "pencil")
                }
                
                Button(action: {
                    showStatusPicker = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .sheet(isPresented: $showStatusPicker) {
            StatusPickerView(
                currentStatus: viewModel.repair.status,
                onSelect: { status in
                    Task {
                        await viewModel.updateStatus(status)
                    }
                }
            )
        }
        .sheet(isPresented: $showEditView) {
            NavigationStack {
                RepairFormView(
                    viewModel: RepairFormViewModel(
                        repository: viewModel.repository,
                        imageService: ImageStorageService(),
                        repair: viewModel.repair
                    )
                )
            }
            .onDisappear {
                // Recargar la reparación cuando se cierra el editor
                Task {
                    if let updatedRepair = try? await viewModel.repository.fetchRepair(id: viewModel.repair.id) {
                        viewModel.repair = updatedRepair
                        viewModel.loadImages()
                    }
                }
            }
        }
        .alert("Eliminar Reparación", isPresented: $showDeleteConfirmation) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                Task {
                    await viewModel.deleteRepair()
                    dismiss()
                }
            }
        } message: {
            Text("¿Estás seguro de que deseas eliminar esta reparación? Esta acción no se puede deshacer.")
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            showDeleteConfirmation = true
        }) {
            HStack {
                Image(systemName: "trash")
                Text("Eliminar Reparación")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red)
            )
        }
        .padding(.horizontal)
    }
    
    private var headerSection: some View {
        GlassCard {
            VStack(spacing: 16) {
                HStack {
                    if let folio = viewModel.repair.folio, !folio.isEmpty {
                        Text(folio)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.secondary.opacity(0.15))
                            )
                    }
                    
                    ZStack {
                        Circle()
                            .fill(viewModel.repair.device.type.color.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: viewModel.repair.device.type.icon)
                            .font(.system(size: 30))
                            .foregroundColor(viewModel.repair.device.type.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.repair.device.displayName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(viewModel.repair.customer.fullName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                Button(action: {
                    showStatusPicker = true
                }) {
                    HStack {
                        StatusBadge(status: viewModel.repair.status, size: 20)
                        Text(viewModel.repair.status.rawValue)
                            .font(.headline)
                            .foregroundColor(viewModel.repair.status.color)
                        Spacer()
                        Image(systemName: "pencil.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue.opacity(0.7))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var customerSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Información del Cliente")
                    .font(.headline)
                
                InfoRow(icon: "person.fill", title: "Nombre", value: viewModel.repair.customer.fullName)
                InfoRow(icon: "phone.fill", title: "Teléfono", value: viewModel.repair.customer.phone)
                InfoRow(icon: "envelope.fill", title: "Email", value: viewModel.repair.customer.email)
                InfoRow(icon: "mappin.circle.fill", title: "Dirección", value: viewModel.repair.customer.address)
            }
        }
    }
    
    private var deviceSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Información del Dispositivo")
                    .font(.headline)
                
                InfoRow(icon: "tag.fill", title: "Tipo", value: viewModel.repair.device.type.rawValue)
                InfoRow(icon: "building.fill", title: "Marca", value: viewModel.repair.device.brand)
                InfoRow(icon: "cube.box.fill", title: "Modelo", value: viewModel.repair.device.model)
                if !viewModel.repair.device.serialNumber.isEmpty {
                    InfoRow(icon: "number", title: "Número de serie", value: viewModel.repair.device.serialNumber)
                }
                InfoRow(icon: "key.fill", title: "Contraseña", value: viewModel.repair.device.password)
            }
        }
    }
    
    private var statusSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Estado y Fechas")
                        .font(.headline)
                    Spacer()
                }
                
                // Botón para cambiar estado - más visible
                Button(action: {
                    showStatusPicker = true
                }) {
                    HStack {
                        StatusBadge(status: viewModel.repair.status, size: 20)
                        Text(viewModel.repair.status.rawValue)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.repair.status.color.opacity(0.1))
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Fecha de recepción")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(viewModel.repair.receivedDate.formatted(date: .long, time: .shortened))
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    if let deliveryDate = viewModel.repair.deliveryDate {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Fecha de entrega")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(deliveryDate.formatted(date: .long, time: .shortened))
                                .font(.subheadline)
                        }
                    }
                }
                
                if viewModel.repair.daysInRepair > 0 {
                    Divider()
                    HStack {
                        Text("Días en reparación:")
                            .font(.subheadline)
                        Spacer()
                        Text("\(viewModel.repair.daysInRepair)")
                            .font(.headline)
                            .foregroundColor(viewModel.repair.isOverdue ? .red : .blue)
                    }
                }
            }
        }
    }
    
    private var problemSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Descripción del Problema")
                    .font(.headline)
                
                Text(viewModel.repair.problemDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var priceSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Precio")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    Text(viewModel.repair.formattedPrice)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                }
            }
        }
    }
    
    private var workSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Trabajo Realizado")
                    .font(.headline)
                
                if !viewModel.repair.workPerformed.isEmpty {
                    Text(viewModel.repair.workPerformed)
                        .font(.body)
                        .foregroundColor(.secondary)
                } else {
                    Text("No se ha registrado trabajo realizado")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .italic()
                }
                
                if !viewModel.repair.notes.isEmpty {
                    Divider()
                    Text("Notas:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.repair.notes)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var imageGallerySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Tipo de imágenes", selection: $isShowingInitial) {
                Text("Daño inicial").tag(true)
                Text("Después de reparación").tag(false)
            }
            .pickerStyle(.segmented)
            
            let images = isShowingInitial ? viewModel.initialImageUIs : viewModel.finalImageUIs
            
            if images.isEmpty {
                Text("No hay imágenes para este tipo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                            Button(action: {
                                selectedImageIndex = index
                                showImageFullscreen = true
                            }) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showImageFullscreen) {
            ImageFullscreenView(
                images: isShowingInitial ? viewModel.initialImageUIs : viewModel.finalImageUIs,
                currentIndex: selectedImageIndex
            )
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value.isEmpty ? "No especificado" : value)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
}

struct StatusPickerView: View {
    let currentStatus: RepairStatus
    let onSelect: (RepairStatus) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Información del estado actual
                VStack(spacing: 12) {
                    Text("Estado Actual")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        StatusBadge(status: currentStatus, size: 24)
                        Text(currentStatus.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(currentStatus.color)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(currentStatus.color.opacity(0.1))
                
                // Lista de estados disponibles
                List {
                    Section {
                        ForEach(RepairStatus.allCases) { status in
                            Button(action: {
                                onSelect(status)
                                dismiss()
                            }) {
                                HStack(spacing: 16) {
                                    StatusBadge(status: status, size: 20)
                                    Text(status.rawValue)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if status == currentStatus {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                            .font(.title3)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    } header: {
                        Text("Selecciona un nuevo estado")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Cambiar Estado")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ImageFullscreenView: View {
    let images: [UIImage]
    let currentIndex: Int
    @Environment(\.dismiss) var dismiss
    @State private var currentImageIndex: Int
    
    init(images: [UIImage], currentIndex: Int) {
        self.images = images
        self.currentIndex = currentIndex
        _currentImageIndex = State(initialValue: currentIndex)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                TabView(selection: $currentImageIndex) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
            }
            .navigationTitle("\(currentImageIndex + 1) de \(images.count)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RepairDetailView(
            viewModel: RepairDetailViewModel(
                repair: Repair(
                    customer: Customer(fullName: "Juan Pérez", phone: "1234567890"),
                    device: Device(type: .phone, brand: "Apple", model: "iPhone 14"),
                    problemDescription: "Pantalla rota",
                    status: .repairing
                ),
                repository: RepairRepositoryImpl(
                    storageService: LocalStorageService()
                )
            )
        )
    }
}


