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
            guard let results = request.results as? [VNClassificationObservation] else {
                completion(nil)
                return
            }

            let clothingCategories = ["t-shirt", "pants", "jeans", "shorts", "jacket", "sweater", "dress", "coat", "shoes", "sneaker", "boot", "sandal", "loafer", "high_heel"]
            let filteredResults = results.filter { clothingCategories.contains($0.identifier) && $0.confidence > 0.3 }
            let sortedResults = filteredResults.sorted { $0.confidence > $1.confidence }
            for result in sortedResults {
                print("✅ Filtered: \(result.identifier) - Confidence: \(result.confidence)")
            }

            if let topResult = sortedResults.first {
                let category = self.mapToClosetCategory(topResult.identifier)
                completion(category)
            } else {
                completion("Unknown")
            }
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
            "t-shirt": "Tops",
            "shirt": "Tops",
            "sweater": "Tops",
            "jacket": "Outerwear",
            "coat": "Outerwear",
            "pants": "Bottoms",
            "jeans": "Bottoms",
            "shorts": "Bottoms",
            "dress": "Dresses",
            "shoes": "Footwear",
            "sneaker": "Footwear",
            "boot": "Footwear",
            "sandal": "Footwear",
            "loafer": "Footwear",
            "high_heel": "Footwear"
        ]
        
        return mapping[identifier] ?? "Unknown"
    }

}
