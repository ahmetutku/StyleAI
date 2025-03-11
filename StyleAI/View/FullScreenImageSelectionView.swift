import SwiftUI

struct FullScreenImageSelectionView: View {
    @State private var processedImage: UIImage?
    @State private var isProcessing = false
    @ObservedObject var viewModel: ClosetViewModel
    let image: UIImage
    let categories = ["Outerwear", "Shirts", "Pants", "Footwear"]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("background_color").ignoresSafeArea()
            
            VStack {
                // Category Selector
                Picker("Category", selection: $viewModel.selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Display Image
                Image(uiImage: processedImage ?? image)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(maxHeight: 400)

                Spacer()

                // Action Buttons
                HStack {
                    Button(action: addToCloset) {
                        Text("Add to Closet")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

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

    private func addToCloset() {
        let filename = "\(UUID().uuidString).png"
        ImageStorage.saveImage(processedImage ?? image, named: filename)
        let newItem = ClosetItemImage(id: UUID(), filename: filename, category: viewModel.selectedCategory)
        viewModel.images.append(newItem)
        viewModel.saveClosetItems()
        dismiss()
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
