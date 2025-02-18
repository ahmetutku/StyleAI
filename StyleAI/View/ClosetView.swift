//
//  ClosetView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 30.01.2025.
//
import SwiftUI
import PhotosUI

struct ClosetView: View {
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var showingAlert = false
    @State private var closetImage: UIImage?
    @State var closetItems: [PhotosPickerItem] = []
    @State var images: [ClosetItemImage] = []
    @State private var isProcessing = false
    @State private var selectedImage: ClosetItemImage?

    
    var body: some View {
        ZStack {
            Color("background_color")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("My Closet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(.accentColor)
                
                Spacer()
                ScrollView {
                    let columns = [GridItem(.adaptive(minimum: 120), spacing: 10)]
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(images) {image in
                            Image(uiImage: image.closetImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: CGFloat.random(in: 90...100))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 10)
                                .onTapGesture {
                                    selectedImage = image
                                }
                        }
                    }
                    .padding()
                }
                Spacer()
                if let closetImage = closetImage {
                    Image(uiImage: closetImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    
                    Button(action: {
                        removeBackground()
                    }) {
                        if isProcessing {
                            ProgressView()
                        } else {
                            Text("Remove Background")
                                .padding()
                                .font(.title2)
                                .fontWeight(.bold)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(isProcessing)
                }
                
                Button(action: {
                    showingAlert = true
                }) {
                    Text("Add a Piece")
                        .padding()
                        .font(.title2)
                        .fontWeight(.bold)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .confirmationDialog("Choose an Option", isPresented: $showingAlert, titleVisibility: .visible) {
                    Button("Take a Picture") {
                        showCamera = true
                    }
                    Button("Choose from Library") {
                        showPhotoPicker = true
                    }
                }
                .fullScreenCover(item: $selectedImage) { selectedImage in
                    FullScreenClosetImageView(originalImage: selectedImage.closetImage) { updatedImage in
                        updateClosetItem(with: selectedImage.id, newImage: updatedImage)
                    }
                }

                
                .photosPicker(isPresented: $showPhotoPicker, selection: $closetItems, matching: .images)
                .onChange(of: closetItems) { newItems in
                    images = []
                    for item in newItems {
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let imageData):
                                if let imageData, let uiImage = UIImage(data: imageData) {
                                    DispatchQueue.main.async {
                                        self.images.append(ClosetItemImage(id: UUID(), closetImage: uiImage))
                                    }
                                } else {
                                    print("No supported content type found.")
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func updateClosetItem(with id: UUID, newImage: UIImage) {
        if let index = images.firstIndex(where: { $0.id == id }) {
            images[index] = ClosetItemImage(id: id, closetImage: newImage)
        }
    }

    
    private func removeBackground() {
        guard let image = closetImage else { return }
        isProcessing = true 

        BackgroundRemover.shared.removeBackground(from: image) { processedImage in
            DispatchQueue.main.async {
                if let result = processedImage {
                    closetImage = result
                }
                isProcessing = false
            }
        }
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}

