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
    @State private var selectedImage: ClosetItemImage?
    
    @State private var closetItems: [PhotosPickerItem] = []
    @State private var images: [ClosetItemImage] = []
    @State private var showUnrecognizedAlert = false

    var body: some View {
        ZStack {
            Color("background_color").ignoresSafeArea()
            
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
                        ForEach(images) { image in
                            if let uiImage = image.closetImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 5)
                                    .onTapGesture {
                                        selectedImage = image
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            removeClosetItem(image)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
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
                .photosPicker(isPresented: $showPhotoPicker, selection: $closetItems, matching: .images)
                .onChange(of: closetItems) { newItems in
                    addNewClosetImages(from: newItems)
                }
                .fullScreenCover(item: $selectedImage) { selectedImage in
                    FullScreenClosetImageView(originalImage: selectedImage.closetImage ?? UIImage(), onUpdate: { updatedImage in
                        updateClosetItem(with: selectedImage.id, newImage: updatedImage)
                    })
                }
            }
        }
        .onAppear {
            loadClosetItems()
        }
        .alert("Item Not Recognized", isPresented: $showUnrecognizedAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text("This item could not be classified as clothing and was not added to your closet.")
        })
    }

    // MARK: - Remove Closet Item
    private func removeClosetItem(_ item: ClosetItemImage) {
        if let index = images.firstIndex(where: { $0.id == item.id }) {

            ImageStorage.deleteImage(named: images[index].filename)
            images.remove(at: index)
            saveClosetItems()
        }
    }

    // MARK: - Add New Images
    private func addNewClosetImages(from newItems: [PhotosPickerItem]) {
        for item in newItems {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let imageData):
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        let filename = "\(UUID().uuidString).png"
                        ImageStorage.saveImage(uiImage, named: filename)

                        ClothingClassifier.shared.classifyImage(uiImage) { category in
                            DispatchQueue.main.async {
                                if let category = category, category != "Unknown" {
                                    let closetItem = ClosetItemImage(id: UUID(), filename: filename, category: category)
                                    self.images.append(closetItem)
                                    saveClosetItems()
                                } else {
                                    // Show an alert if the item is unrecognized
                                    showUnrecognizedAlert = true
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
    }

    // MARK: - Update Image after Background Removal
    private func updateClosetItem(with id: UUID, newImage: UIImage) {
        if let index = images.firstIndex(where: { $0.id == id }) {
            let newFilename = "\(UUID().uuidString).png"
            ImageStorage.saveImage(newImage, named: newFilename)
            
            // Delete old image
            ImageStorage.deleteImage(named: images[index].filename)
            
            // Update closet image
            images[index] = ClosetItemImage(id: id, filename: newFilename)
            saveClosetItems()
        }
    }

    // MARK: - Save & Load Closet Items
    private func saveClosetItems() {
        if let encoded = try? JSONEncoder().encode(images) {
            UserDefaults.standard.set(encoded, forKey: "closetItems")
        }
    }

    private func loadClosetItems() {
        if let savedData = UserDefaults.standard.data(forKey: "closetItems"),
           let decoded = try? JSONDecoder().decode([ClosetItemImage].self, from: savedData) {
            images = decoded
        }
    }
}


