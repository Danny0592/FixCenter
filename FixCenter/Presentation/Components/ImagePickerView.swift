//
//  ImagePickerView.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import SwiftUI
import UIKit

struct ImagePickerView: View {
    @Binding var selectedImages: [UIImage]
    let title: String
    let maxImages: Int
    
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    
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
                                    .foregroundColor(.white)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }
                            .offset(x: 8, y: -8)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

struct PhotoPickerView: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
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

struct CameraView: UIViewControllerRepresentable {
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

