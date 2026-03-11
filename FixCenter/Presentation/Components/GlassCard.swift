//
//  GlassCard.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
// TODO: Componente de "Glass Card" tarjeta de resumen de servicio
/// Un contenedor con efecto de cristal (glassmorphism) y desenfoque de fondo.
struct GlassCard<Content: View>: View {
    /// El contenido que se mostrará dentro de la tarjeta.
    let content: Content
    /// Radio de curvatura de las esquinas.
    var cornerRadius: CGFloat = AppConstants.cornerRadius
    /// Espaciado interno de la tarjeta.
    var padding: CGFloat = AppConstants.cardPadding
    
    /// Estado interno para gestionar animaciones de pulsación (si se requiere).
    @State private var isPressed = false
    
    /// Inicializa una nueva tarjeta de cristal.
    /// - Parameters:
    ///   - cornerRadius: Radio de las esquinas.
    ///   - padding: Margen interno.
    ///   - content: Constructor de la vista de contenido.
    init(
        cornerRadius: CGFloat = AppConstants.cornerRadius,
        padding: CGFloat = AppConstants.cardPadding,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AppColors.glassBackground)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.ultraThinMaterial)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

#Preview {
    GlassCard {
        Text("Glass Card Preview")
            .font(.headline)
    }
    .padding()
}


