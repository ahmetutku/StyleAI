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

            let sortedResults = results.sorted { $0.confidence > $1.confidence }
            print("🔍 Top 5 Predictions:")
            for (index, result) in sortedResults.prefix(5).enumerated() {
                print("  \(index + 1). \(result.identifier) - Confidence: \(result.confidence)")
            }

            let clothingCategories = ["t-shirt", "pants", "trousers", "jeans", "shorts", "jacket", "sweater", "dress", "coat", "shoes", "sneaker", "boot", "sandal", "loafer", "high_heel"]
            
            let filteredResults = sortedResults.filter { clothingCategories.contains($0.identifier) && $0.confidence > 0.3 }

            if let topResult = filteredResults.first {
                let category = self.mapToClosetCategory(topResult.identifier)
                completion(category)
                return
            }
            
            let top5Identifiers = sortedResults.prefix(5).map { $0.identifier.lowercased() }
            let containsClothing = top5Identifiers.contains("clothing")
            let hasOtherClothingItems = top5Identifiers.contains { clothingCategories.contains($0) }

            if containsClothing && !hasOtherClothingItems {
                // ❗ Only "clothing" detected → Ask user for the category
                DispatchQueue.main.async {
                    self.askUserForCategory { userCategory in
                        completion(userCategory)
                    }
                }
                return
            }

            completion("Unknown")
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

    private func askUserForCategory(completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Unrecognized Clothing", message: "What type of clothing is this?", preferredStyle: .alert)

        for category in ["Tops", "Bottoms", "Outerwear", "Dresses", "Footwear"] {
            alertController.addAction(UIAlertAction(title: category, style: .default) { _ in
                completion(category)
            })
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        })

        DispatchQueue.main.async {
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                topController.present(alertController, animated: true)
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
            "trousers":"Bottoms",
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
