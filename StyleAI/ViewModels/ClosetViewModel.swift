//
//  ClosetViewModel.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 22.02.2025.
//


import SwiftUI
import PhotosUI

class ClosetViewModel: ObservableObject {
    @Published var images: [ClosetItemImage] = []
    @Published var closetItems: [PhotosPickerItem] = []
    @Published var showPhotoPicker = false
    @Published var showCamera = false
    @Published var showUnrecognizedAlert = false
    @Published var isMenuOpen = false
    @Published var tempImage: UIImage?
    @Published var selectedCategory: String = "Shirts"
    @Published var showFullScreenSelection = false

    
    var categorizedCloset: [String: [ClosetItemImage]] {
        Dictionary(grouping: images, by: { $0.category })
    }
    
    var orderedCategories: [String] {
        let categoryOrder = ["Outerwear", "Tops", "Bottoms", "Dresses", "Footwear"]
        return categoryOrder.filter { categorizedCloset[$0] != nil }
    }

    
    init() {
            loadClosetItems()
        }

    func addNewClosetImages(from newItems: [PhotosPickerItem]) {
        for item in newItems {
            item.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
                        if let imageData, let uiImage = UIImage(data: imageData) {
                            self.tempImage = uiImage
                            self.showFullScreenSelection = true
                        }
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            }
        }
    }



    func removeClosetItem(_ item: ClosetItemImage) {
        if let index = images.firstIndex(where: { $0.id == item.id }) {
            ImageStorage.deleteImage(named: images[index].filename)
            images.remove(at: index)
            saveClosetItems()
        }
    }

    func saveClosetItems() {
        if let encoded = try? JSONEncoder().encode(images) {
            UserDefaults.standard.set(encoded, forKey: "closetItems")
        }
    }

    func loadClosetItems() {
        if let savedData = UserDefaults.standard.data(forKey: "closetItems"),
           let decoded = try? JSONDecoder().decode([ClosetItemImage].self, from: savedData) {
            images = decoded
        }
    }
    
    func updateClosetItem(with id: UUID, newImage: UIImage) {
        if let index = images.firstIndex(where: { $0.id == id }) {
            let newFilename = "\(UUID().uuidString).png"
            ImageStorage.saveImage(newImage, named: newFilename)
            ImageStorage.deleteImage(named: images[index].filename)
            
            let category = images[index].category // Keep the original category
            images[index] = ClosetItemImage(id: id, filename: newFilename, category: category)
            
            saveClosetItems()
        }
    }
}
