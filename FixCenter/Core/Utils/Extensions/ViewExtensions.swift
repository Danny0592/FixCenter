//
//  ViewExtensions.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI

extension View {
    /// Aplica un efecto de cristal (glassmorphism) a la vista.
    /// Utiliza .ultraThinMaterial y añade bordes redondeados y sombra.
    func glassEffect() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(AppConstants.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    /// Aplica el estilo estándar de tarjeta de la aplicación.
    /// Incluye padding, fondo de tarjeta, bordes redondeados y una sombra sutil.
    func cardStyle() -> some View {
        self
            .padding(AppConstants.cardPadding)
            .background(AppColors.cardBackground)
            .cornerRadius(AppConstants.cornerRadius)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    /// Cierra el teclado automáticamente cuando el usuario toca la vista.
    /// Utiliza `simultaneousGesture` para evitar conflictos con otros gestos como scrolls o botones.
    func hideKeyboardOnTap() -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
    }
    
    /// Cierra el teclado de forma programática.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


