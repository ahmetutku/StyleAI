//
//  FitView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 24.02.2025.
//
import SwiftUI

struct FitView: View {
    @StateObject private var viewModel = ClosetViewModel()
    @State private var selectedItems: [String: ClosetItemImage] = [:]
    @State private var selectedIndices: [String: Int] = [:]
    @State private var menuPosition: CGPoint = .zero
    @State private var isMenuOpen: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("background_color").ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Create Your Fit")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(.accentColor)
        
                    fitScrollView
                    addFitButton
                    
                }
                menuButton
                    .position(x: 30, y: 50)
                
                if isMenuOpen {
                    DropdownMenuView(isMenuOpen: $viewModel.isMenuOpen)
                }
            }
            .onAppear { initializeSelections() }
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    private var menuButton: some View {
            GeometryReader { geometry in
                Button(action: {
                    withAnimation {
                        isMenuOpen.toggle()
                        menuPosition = CGPoint(
                            x: geometry.frame(in: .global).minX + 20,
                            y: geometry.frame(in: .global).maxY + 10
                        )
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                }
            }
            .frame(width: 44, height: 44)
        }

    private var fitScrollView: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.orderedCategories, id: \.self) { category in
                    if let items = viewModel.categorizedCloset[category], !items.isEmpty {
                        fitCategoryView(category: category, items: items)
                    }
                }
            }
        }
    }

    private func fitCategoryView(category: String, items: [ClosetItemImage]) -> some View {
        VStack {
            Text(category)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)

            HStack {
                Button(action: { navigateItems(for: category, direction: -1, items: items) }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .padding()
                }
                .disabled(items.count <= 1)

                if let selectedIndex = selectedIndices[category], items.indices.contains(selectedIndex) {
                    Image(uiImage: items[selectedIndex].closetImage ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                }

                Button(action: { navigateItems(for: category, direction: 1, items: items) }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .padding()
                }
                .disabled(items.count <= 1)
            }
        }
        .padding(.horizontal)
    }

    private var addFitButton: some View {
        Button(action: saveFit) {
            Text("Add Fit")
                .padding()
                .font(.title2)
                .fontWeight(.bold)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }

    private func initializeSelections() {
        for category in viewModel.orderedCategories {
            if let firstItem = viewModel.categorizedCloset[category]?.first {
                selectedItems[category] = firstItem
                selectedIndices[category] = 0
            }
        }
    }

    private func navigateItems(for category: String, direction: Int, items: [ClosetItemImage]) {
        if let currentIndex = selectedIndices[category] {
            let newIndex = (currentIndex + direction + items.count) % items.count
            selectedIndices[category] = newIndex
            selectedItems[category] = items[newIndex]
        }
    }

    private func saveFit() {
        let outfit = selectedItems.mapValues { $0.filename }
        UserDefaults.standard.set(outfit, forKey: "savedFit")
    }
}

struct FitView_Previews: PreviewProvider {
    static var previews: some View {
        FitView()
    }
}


