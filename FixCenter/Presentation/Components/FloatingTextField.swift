//
//  FloatingTextField.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
// TODO: Componente de "placeholder"
struct FloatingTextField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    var focusState: FocusState<RepairFormField?>.Binding? = nil
    var focusValue: RepairFormField? = nil
    
    @FocusState private var internalIsFocused: Bool
    @State private var borderColor: Color = .gray.opacity(0.3)
    
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
            
            HStack {
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
        FloatingTextField(
            title: "Nombre completo",
            text: .constant(""),
            placeholder: "Ingresa el nombre"
        )
        
        FloatingTextField(
            title: "Teléfono",
            text: .constant(""),
            placeholder: "Ingresa el teléfono",
            keyboardType: .phonePad
        )
    }
    .padding()
}


