//
//  FloatingTextField.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
// TODO: Componente de "placeholder"
/// Un campo de texto personalizado con etiqueta flotante y soporte para iconos y estados de foco.
struct FloatingTextField<F: Hashable>: View {
    /// El título que se muestra arriba del campo.
    let title: String
    /// Enlace al texto ingresado en el campo.
    @Binding var text: String
    /// Texto de sugerencia cuando el campo está vacío.
    var placeholder: String = ""
    /// Tipo de teclado que se mostrará.
    var keyboardType: UIKeyboardType = .default
    /// Si es true, oculta el texto (para contraseñas).
    var isSecure: Bool = false
    /// Nombre del icono de SF Symbols opcional.
    var icon: String? = nil
    /// Enlace al estado de foco global del formulario.
    var focusState: FocusState<F?>.Binding? = nil
    /// El valor de este campo en el enum de foco.
    var focusValue: F? = nil
    
    /// Estado de foco interno.
    @FocusState private var internalIsFocused: Bool
    /// Color del borde que cambia según el estado de foco.
    @State private var borderColor: Color = .gray.opacity(0.3)
    
    /// Determina si el campo está actualmente enfocado.
    private var isCurrentlyFocused: Bool {
        if let focusState = focusState, let focusValue = focusValue {
            return focusState.wrappedValue == focusValue
        }
        return internalIsFocused
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.blue)
            
            HStack(spacing: 12) {
                if let iconName = icon {
                    Image(systemName: iconName)
                        .foregroundColor(.blue.opacity(0.8))
                        .font(.system(size: 18))
                        .frame(width: 20)
                }
                
                /// Campo de entrada de texto.
                ZStack(alignment: .leading) {
                    if text.isEmpty && !isCurrentlyFocused {
                        Text(placeholder.isEmpty ? title : placeholder)
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    
                    Group {
                        if isSecure {
                            SecureField("", text: $text)
                        } else {
                            TextField("", text: $text)
                        }
                    }
                    .ifLet(focusState, focusValue) { view, state, value in
                        view.focused(state, equals: value)
                    }
                    .focused($internalIsFocused)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
                
                /// Botón para limpiar el contenido del campo.
                if !text.isEmpty && isCurrentlyFocused {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.system(size: 16))
                    }
                    .transition(.opacity)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: 2)
                    )
            )
        }
        .onChange(of: isCurrentlyFocused) { focused in
            withAnimation(.easeInOut(duration: 0.2)) {
                borderColor = focused ? .blue : .gray.opacity(0.3)
            }
        }
    }
}

extension View {
    @ViewBuilder
    func ifLet<T, V, Content: View>(_ optional1: T?, _ optional2: V?, transform: (Self, T, V) -> Content) -> some View {
        if let optional1 = optional1, let optional2 = optional2 {
            transform(self, optional1, optional2)
        } else {
            self
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        FloatingTextField<RepairFormField>(
            title: "Nombre completo",
            text: .constant(""),
            placeholder: "Ingresa el nombre"
        )
        
        FloatingTextField<RepairFormField>(
            title: "Teléfono",
            text: .constant(""),
            placeholder: "Ingresa el teléfono",
            keyboardType: .phonePad
        )
    }
    .padding()
}


