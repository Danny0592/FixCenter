//
//  LoginViewModel.swift
//  FixCenter
//
//  Created by antigravity on 09/03/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Callback for successful login
    var onLoginSuccess: (() -> Void)?
    
    func login() {
        guard !username.isEmpty && !password.isEmpty else {
            errorMessage = "Por favor, completa todos los campos"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simular proceso de autenticación
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            
            // Simulación simple: cualquier credencial es válida
            // Podríamos añadir validación específica si el usuario lo requiere
            if !self.username.isEmpty {
                self.onLoginSuccess?()
            } else {
                self.errorMessage = "Credenciales inválidas"
            }
        }
    }
}
