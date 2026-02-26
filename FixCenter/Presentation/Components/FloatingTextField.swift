//
//  FloatingTextField.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI

struct FloatingTextField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    @FocusState private var isFocused: Bool
    @State private var borderColor: Color = .gray.opacity(0.3)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !text.isEmpty || isFocused {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            ZStack(alignment: .leading) {
                if text.isEmpty && !isFocused {
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
                .focused($isFocused)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Listo") {
                            isFocused = false
                        }
                        .foregroundColor(.blue)
                    }
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
        .onChange(of: isFocused) { focused in
            withAnimation(.easeInOut(duration: 0.2)) {
                borderColor = focused ? .blue : .gray.opacity(0.3)
            }
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


