//
//  FullScreenImageSelectionView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 11.03.2025.
//


import SwiftUI

struct FullScreenImageSelectionView: View {
    @State private var processedImage: UIImage?
    @State private var isProcessing = false
    @State private var showCategoryDropdown = false
    @State private var selectedCategory: String?
    @ObservedObject var viewModel: ClosetViewModel
    let image: UIImage
    let categories = ["Outerwear", "Tops", "Bottoms", "Footwear"]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("background_color").ignoresSafeArea()

            VStack {
                // Category Selection Button
                Button(action: { showCategoryDropdown.toggle() }) {
                    HStack {
                        Text(selectedCategory ?? "Select Category")
                            .foregroundColor(selectedCategory == nil ? .gray : .white)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }
                .padding()
                .popover(isPresented: $showCategoryDropdown) {
                    categoryDropdown
                }

                // Image Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 300, height: 400)
                    
                    Image(uiImage: processedImage ?? image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 380)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                }
                .padding()

                Spacer()

                // Action Buttons
                HStack {
                    Button(action: addToCloset) {
                        Text("Add to Closet")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedCategory == nil ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(selectedCategory == nil)

                    Button(action: removeBackground) {
                        if isProcessing {
                            ProgressView()
                        } else {
                            Text("Remove Background")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
    }

    private var categoryDropdown: some View {
        VStack(spacing: 10) {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                    showCategoryDropdown = false
                }) {
                    Text(category)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color("background_color"))
        .cornerRadius(10)
        .frame(width: 250)
    }

    private func addToCloset() {
        guard let category = selectedCategory else { return } // Ensure category is selected

        let finalImage = processedImage ?? image // Use processed image if available, otherwise original
        let filename = "\(UUID().uuidString).png"
        ImageStorage.saveImage(finalImage, named: filename)

        let newItem = ClosetItemImage(id: UUID(), filename: filename, category: category)

        DispatchQueue.main.async {
            viewModel.images.append(newItem)
            viewModel.saveClosetItems()
            dismiss()
        }
    }


    private func removeBackground() {
        isProcessing = true
        BackgroundRemover.shared.removeBackground(from: image) { result in
            DispatchQueue.main.async {
                if let resultImage = result {
                    processedImage = resultImage
                }
                isProcessing = false
            }
        }
    }
}

