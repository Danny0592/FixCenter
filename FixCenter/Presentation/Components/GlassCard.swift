//
//  GlassCard.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
// TODO: Componente de "Glass Card "
struct GlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = AppConstants.cornerRadius
    var padding: CGFloat = AppConstants.cardPadding
    
    @State private var isPressed = false
    
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


