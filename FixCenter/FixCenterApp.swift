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
    
    var body: some Scene {
        WindowGroup {
            RepairListView(
                viewModel: RepairListViewModel(
                    repository: repairRepository
                )
            )
        }
    }
}
