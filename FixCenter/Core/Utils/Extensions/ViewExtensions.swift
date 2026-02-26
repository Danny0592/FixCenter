//
//  ViewExtensions.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI

extension View {
    func glassEffect() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(AppConstants.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    func cardStyle() -> some View {
        self
            .padding(AppConstants.cardPadding)
            .background(AppColors.cardBackground)
            .cornerRadius(AppConstants.cornerRadius)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    /// Cierra el teclado cuando se toca fuera del campo
    /// Usa simultaneousGesture para no interferir con otros gestos
    func hideKeyboardOnTap() -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
    }
    
    /// Cierra el teclado programáticamente
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


