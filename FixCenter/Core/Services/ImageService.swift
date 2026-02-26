//
//  ImageService.swift
//  FixCenter
//
//  Created by daniel ortiz millan on 05/12/25.
//

import Foundation
import UIKit
import SwiftUI

protocol ImageService {
    func compressImage(_ image: UIImage, maxSizeKB: Int) -> Data?
    func saveImage(_ data: Data, filename: String) throws -> URL
    func loadImage(from url: URL) -> UIImage?
    func deleteImage(at url: URL) throws
}


