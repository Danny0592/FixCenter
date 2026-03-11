//
//  ImagePickerView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
import UIKit
/// Componente para la selección y visualización de múltiples imágenes.
/// Permite capturar fotos con la cámara o seleccionarlas de la galería.
struct ImagePickerView: View {
    /// Lista de imágenes seleccionadas por el usuario.
    @Binding var selectedImages: [UIImage]
    /// Título de la sección.
    let title: String
    /// Cantidad máxima de imágenes permitidas.
    let maxImages: Int
    
    /// Controla la visibilidad de la cámara.
    @State private var showCamera = false
    /// Controla la visibilidad del selector de fotos.
    @State private var showPhotoPicker = false
    
    /// Inicializa el selector de imágenes.
    init(
        selectedImages: Binding<[UIImage]>,
        title: String = "Seleccionar imágenes",
        maxImages: Int = 10
    ) {
        self._selectedImages = selectedImages
        self.title = title
        self.maxImages = maxImages
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Botón para agregar imágenes
                    if selectedImages.count < maxImages {
                        Menu {
                            Button(action: {
                                showCamera = true
                            }) {
                                Label("Cámara", systemImage: "camera.fill")
                            }
                            
                            Button(action: {
                                showPhotoPicker = true
                            }) {
                                Label("Galería", systemImage: "photo.on.rectangle")
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                
                                VStack(spacing: 4) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    Text("Agregar")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .sheet(isPresented: $showCamera) {
                            CameraView(selectedImage: { image in
                                selectedImages.append(image)
                            })
                        }
                        .sheet(isPresented: $showPhotoPicker) {
                            PhotoPickerView(selectedImages: $selectedImages, maxSelection: maxImages - selectedImages.count)
                        }
                    }
                    
                    // Imágenes seleccionadas
                    ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Button(action: {
                                selectedImages.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }
                            .offset(x: -4, y: 4)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

/// Adaptador para utilizar el selector de fotos nativo de iOS en SwiftUI.
struct PhotoPickerView: UIViewControllerRepresentable {
    /// Referencia a la lista de imágenes seleccionadas.
    @Binding var selectedImages: [UIImage]
    /// Límite de selección.
    let maxSelection: Int
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Coordinador para manejar los delegados de `UIImagePickerController`.
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: PhotoPickerView
        
        init(_ parent: PhotoPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImages.append(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

/// Adaptador para utilizar la cámara nativa de iOS en SwiftUI.
struct CameraView: UIViewControllerRepresentable {
    /// Callback que devuelve la imagen capturada.
    let selectedImage: (UIImage) -> Void
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Coordinador para los delegados de la cámara.
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImage(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    ImagePickerView(
        selectedImages: .constant([]),
        title: "Fotos del daño"
    )
    .padding()
}

