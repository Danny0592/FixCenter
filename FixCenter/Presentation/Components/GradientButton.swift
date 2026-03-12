//
//  GradientButton.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
/// Un botón con fondo degradado que soporta estados de carga e iconos.
struct GradientButton: View {
    /// Texto descriptivo del botón.
    let title: String
    /// Acción que se ejecuta al pulsar el botón.
    let action: () -> Void
    /// El degradado que se aplicará al fondo.
    var gradient: LinearGradient = AppColors.primaryGradient
    /// Nombre del icono de SF Symbols opcional.
    var icon: String? = nil
    /// Si es true, muestra un indicador de carga y deshabilita el botón.
    var isLoading: Bool = false
    /// Si es true, el botón no se expande a todo lo ancho.
    var isCompact: Bool = false
    
    /// Inicializa un nuevo botón degradado.
    init(
        title: String,
        action: @escaping () -> Void,
        gradient: LinearGradient = AppColors.primaryGradient,
        icon: String? = nil,
        isLoading: Bool = false,
        isCompact: Bool = false
    ) {
        self.title = title
        self.action = action
        self.gradient = gradient
        self.icon = icon
        self.isLoading = isLoading
        self.isCompact = isCompact
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: isCompact ? 4 : 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(isCompact ? 0.8 : 1.0)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                }
                
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
            }
            .foregroundColor(.white)
            .frame(maxWidth: isCompact ? nil : .infinity)
            .padding(.horizontal, isCompact ? 12 : 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(gradient)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .disabled(isLoading)
    }
}

#Preview {
    VStack(spacing: 20) {
        GradientButton(title: "Continuar", action: {})
        GradientButton(title: "Guardar", action: {}, icon: "checkmark")
        GradientButton(title: "Cargando...", action: {}, isLoading: true)
    }
    .padding()
}

