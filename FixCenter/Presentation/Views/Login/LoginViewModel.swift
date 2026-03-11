//
//  LoginViewModel.swift
//  FixCenter
//
//  Created by antigravity on 09/03/25.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel encargado de la lógica de negocio para la vista de inicio de sesión.
/// Maneja los estados de carga, errores y la validación de credenciales.
@MainActor
class LoginViewModel: ObservableObject {
    /// Nombre de usuario o correo electrónico ingresado.
    @Published var username = ""
    /// Contraseña ingresada.
    @Published var password = ""
    /// Indica si hay un proceso de autenticación en curso.
    @Published var isLoading = false
    /// Mensaje de error a mostrar en la interfaz si la validación falla.
    @Published var errorMessage: String?
    
    /// Callback para notificar el éxito de la operación.
    var onLoginSuccess: (() -> Void)?
    
    /// Ejecuta el proceso de inicio de sesión.
    /// Valida que los campos no estén vacíos y simula una llamada al servidor con un retraso.
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
            if !self.username.isEmpty {
                self.onLoginSuccess?()
            } else {
                self.errorMessage = "Credenciales inválidas"
            }
        }
    }
}
