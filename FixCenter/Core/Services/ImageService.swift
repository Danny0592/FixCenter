//
//  ImageService.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import UIKit
import SwiftUI

/// Protocolo que define las operaciones para el manejo de imágenes en la aplicación.
/// Incluye compresión, guardado, carga y eliminación de archivos de imagen.
protocol ImageService {
    /// Comprime una imagen para reducir su peso en disco.
    /// - Parameters:
    ///   - image: La imagen `UIImage` a comprimir.
    ///   - maxSizeKB: El tamaño máximo deseado en Kilobytes.
    /// - Returns: Los datos de la imagen comprimida o nil si falla.
    func compressImage(_ image: UIImage, maxSizeKB: Int) -> Data?
    
    /// Guarda los datos de una imagen en el sistema de archivos.
    /// - Parameters:
    ///   - data: Los datos binarios de la imagen.
    ///   - filename: El nombre que se le dará al archivo.
    /// - Returns: La URL local donde se guardó la imagen.
    func saveImage(_ data: Data, filename: String) throws -> URL
    
    /// Carga una imagen desde una URL local.
    /// - Parameter url: La ubicación del archivo de imagen.
    /// - Returns: La imagen `UIImage` cargada o nil si no se encuentra.
    func loadImage(from url: URL) -> UIImage?
    
    /// Elimina un archivo de imagen del almacenamiento.
    /// - Parameter url: La URL del archivo a eliminar.
    func deleteImage(at url: URL) throws
}


