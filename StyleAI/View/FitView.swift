//
//  FitView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 24.02.2025.
//
import SwiftUI

struct FitView: View {
    @StateObject private var viewModel = FitViewModel()
    @Binding var selectedTab: String

    var body: some View {
        NavigationView {
            ZStack {
                Color("background_color").ignoresSafeArea()
                VStack(spacing: 20) {
                    headerView
                    fitScrollView
                    addFitButton
                }
                //add layering options

                if viewModel.isMenuOpen {
                    DropdownMenuView(isMenuOpen: $viewModel.isMenuOpen, selectedTab: $selectedTab)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerView: some View {
        Text("Create Your Fit")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .padding(.top, 10)
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
                Button(action: { viewModel.navigateItems(for: category, direction: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .padding()
                }
                .disabled(items.count <= 1)

                if let selectedIndex = viewModel.selectedIndices[category], items.indices.contains(selectedIndex) {
                    Image(uiImage: items[selectedIndex].closetImage ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Button(action: { viewModel.navigateItems(for: category, direction: 1) }) {
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
        Button(action: viewModel.saveFit) {
            Text("Add Fit")
                .padding()
                .font(.title2)
                .fontWeight(.bold)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

struct FitView_Previews: PreviewProvider {
    static var previews: some View {
        FitView(selectedTab: .constant("Fit"))
    }
}


