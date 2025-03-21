//
//  MyFitViewModel.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 21.03.2025.
//

import SwiftUI

class MyFitViewModel: ObservableObject {
    @Published var savedFits: [[String: String]] = []
    let categoryOrder: [String] = ["Outerwear", "Tops", "Bottoms", "Footwear"]
    
    init () {
        loadSavedFits()
    }
    
    func loadSavedFits() {
        savedFits = UserDefaults.standard.array(forKey: "savedFits") as? [[String: String]] ?? []
    }
    
    func sortedFitItems(_ fit: [String: String]) -> [String] {
            categoryOrder.compactMap { category in
                fit[category]
            }
    }
    
    func deleteFit(at index: Int) {
        guard index < savedFits.count else { return }
        savedFits.remove(at: index)
        UserDefaults.standard.set(savedFits, forKey: "savedFits")
    }


    func loadImage(filename: String) -> UIImage {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentDirectory = paths.first {
            let fileURL = documentDirectory.appendingPathComponent(filename)
            if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                return image
            }
        }
        return UIImage(systemName: "photo") ?? UIImage()
    }
}
