//
//  StatusBadge.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
/// Componente de StatusBadge (circulos)
struct StatusBadge: View {
    let status: RepairStatus
    let size: CGFloat
    
    @State private var isPulsing = false
    
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


