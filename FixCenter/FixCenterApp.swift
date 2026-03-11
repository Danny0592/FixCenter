//
//  FixCenterApp.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI

@main
struct FixCenterApp: App {
    // Inicializar servicios
    private let storageService: StorageService = LocalStorageService()
    private let imageService: ImageService = ImageStorageService()
    
    private var repairRepository: RepairRepository {
        RepairRepositoryImpl(storageService: storageService)
    }
    
    @State private var isAuthenticated = true
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                RepairListView(
                    viewModel: RepairListViewModel(
                        repository: repairRepository
                    )
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            } else {
                LoginView {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isAuthenticated = true
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
            }
        }
    }
}
