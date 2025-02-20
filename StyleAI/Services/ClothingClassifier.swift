//
//  ClothingClassifier.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 19.02.2025.
//


import UIKit
import Vision

class ClothingClassifier {
    static let shared = ClothingClassifier()
    
    private init() {}

    func classifyImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }

        let request = VNClassifyImageRequest { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion(nil)
                return
            }
            
            let category = self.mapToClosetCategory(topResult.identifier)
            completion(category)
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Classification error: \(error)")
                completion(nil)
            }
        }
    }

    private func mapToClosetCategory(_ identifier: String) -> String {
        let mapping: [String: String] = [
            "T-shirt": "Tops",
            "Shirt": "Tops",
            "Pants": "Bottoms",
            "Jeans": "Bottoms",
            "Shorts": "Bottoms",
            "Jacket": "Outerwear",
            "Dress": "Dresses",
            "Shoes": "Footwear"
        ]
        
        return mapping[identifier] ?? "Unknown"
    }
}
