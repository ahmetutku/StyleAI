//
//  ImageStorage.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 18.02.2025.
//


import UIKit

class ImageStorage {
    static let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    static func saveImage(_ image: UIImage, named: String) {
        guard let data = image.pngData() else { return }
        let url = directory.appendingPathComponent(named)
        try? data.write(to: url)
    }

    static func loadImage(named: String) -> UIImage? {
        let url = directory.appendingPathComponent(named)
        return UIImage(contentsOfFile: url.path)
    }

    static func deleteImage(named: String) {
        let url = directory.appendingPathComponent(named)
        try? FileManager.default.removeItem(at: url)
    }
}
