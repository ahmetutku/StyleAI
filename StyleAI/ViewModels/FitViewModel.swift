//
//  FitViewModel.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 18.03.2025.
//


import SwiftUI

class FitViewModel: ObservableObject {
    @Published var selectedItems: [String: ClosetItemImage] = [:]
    @Published var selectedIndices: [String: Int] = [:]
    @Published var isMenuOpen: Bool = false

    private let closetViewModel = ClosetViewModel()

    var orderedCategories: [String] {
        closetViewModel.orderedCategories
    }

    var categorizedCloset: [String: [ClosetItemImage]] {
        closetViewModel.categorizedCloset
    }

    init() {
        initializeSelections()
    }

    func initializeSelections() {
        for category in orderedCategories {
            if let firstItem = categorizedCloset[category]?.first {
                selectedItems[category] = firstItem
                selectedIndices[category] = 0
            }
        }
    }

    func navigateItems(for category: String, direction: Int) {
        guard let items = categorizedCloset[category], let currentIndex = selectedIndices[category] else { return }
        let newIndex = (currentIndex + direction + items.count) % items.count
        selectedIndices[category] = newIndex
        selectedItems[category] = items[newIndex]
    }

    func saveFit() {
        let outfit = selectedItems.mapValues { $0.filename }
        
        var savedFits = UserDefaults.standard.array(forKey: "savedFits") as? [[String: String]] ?? []
        savedFits.append(outfit)
        UserDefaults.standard.set(savedFits, forKey: "savedFits")
    }
}

