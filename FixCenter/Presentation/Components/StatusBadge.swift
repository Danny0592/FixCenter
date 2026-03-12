//
//  StatusBadge.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
/// Componente de StatusBadge (circulos)
/// Un indicador visual (círculo) que representa el estado de una reparación.
/// Incluye un efecto de pulsación animado para estados activos.
struct StatusBadge: View {
    /// El estado de la reparación que define el color y el degradado.
    let status: RepairStatus
    /// Diámetro total del indicador.
    let size: CGFloat
    
    /// Controla la animación de pulsación.
    @State private var isPulsing = false
    
    /// Inicializa la insignia de estado.
    /// - Parameters:
    ///   - status: Estado actual.
    ///   - size: Tamaño (por defecto 20).
    init(status: RepairStatus, size: CGFloat = 20) {
        self.status = status
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(status.gradient)
                .frame(width: size, height: size)
                .scaleEffect(isPulsing ? 1.2 : 1.0)
                .opacity(isPulsing ? 0.6 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: isPulsing
                )
            
            Circle()
                .fill(status.color)
                .frame(width: size * 0.7, height: size * 0.7)
        }
        .onAppear {
            isPulsing = true
        }
    }
}

#Preview {
    HStack {
        ForEach(RepairStatus.allCases) { status in
            StatusBadge(status: status)
        }
    }
    .padding()
}


