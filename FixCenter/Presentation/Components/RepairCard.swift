//
//  RepairCard.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
// TODO: Componente de servicio de reparacion
struct RepairCard: View {
    let repair: Repair
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    // Header con estado y folio
                    HStack {
                        StatusBadge(status: repair.status, size: 20)
                        
                        if let folio = repair.folio, !folio.isEmpty {
                            Text(folio)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.secondary.opacity(0.15))
                                )
                        }
                        
                        Spacer()
                        
                        Text(repair.status.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(repair.status.color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(repair.status.color.opacity(0.15))
                            )
                    }
                    
                    // Información del dispositivo
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(repair.device.type.color.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: repair.device.type.icon)
                                .font(.title2)
                                .foregroundColor(repair.device.type.color)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(repair.device.displayName)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(repair.customer.fullName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    // Descripción del problema (truncada)
                    if !repair.problemDescription.isEmpty {
                        Text(repair.problemDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    // Footer con fechas
                    HStack {
                        Label(
                            repair.receivedDate.formatted(date: .abbreviated, time: .omitted),
                            systemImage: "calendar"
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if repair.daysInRepair > 0 {
                            Text("\(repair.daysInRepair) días")
                                .font(.caption)
                                .foregroundColor(repair.isOverdue ? .red : .secondary)
                        }
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                    .fill(repair.status.color.opacity(0.3))
            )
        }
        .buttonStyle(RepairCardButtonStyle())
    }
}

struct RepairCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    RepairCard(
        repair: Repair(
            customer: Customer(fullName: "Juan Pérez", phone: "1234567890"),
            device: Device(type: .phone, brand: "Apple", model: "iPhone 14"),
            problemDescription: "Pantalla rota, necesita reemplazo",
            status: .repairing
        ),
        onTap: {}
    )
    .padding()
}


