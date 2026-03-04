//
//  GradientButton.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
// TODO: Componente de botones
struct GradientButton: View {
    let title: String
    let action: () -> Void
    var gradient: LinearGradient = AppColors.primaryGradient
    var icon: String? = nil
    var isLoading: Bool = false
    var isCompact: Bool = false
    
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
                        .font(.system(size: isCompact ? 14 : 16))
                }
                
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: isCompact ? 14 : 16))
            }
            .foregroundColor(.white)
            .frame(maxWidth: isCompact ? nil : .infinity)
            .padding(.horizontal, isCompact ? 12 : 16)
            .padding(.vertical, isCompact ? 10 : 14)
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

