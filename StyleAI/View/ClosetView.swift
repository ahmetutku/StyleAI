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
    @State private var avatarImage: UIImage?
    @State private var avatarItem: PhotosPickerItem?
    @State var selectedItems: [PhotosPickerItem] = []
    @State var images: [UIImage] = []
    @State private var isProcessing = false
    
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
                
                if let avatarImage = avatarImage {
                    Image(uiImage: avatarImage)
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
                    .disabled(isProcessing) // Disable when processing
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
                .fullScreenCover(isPresented: $showCamera) {
                    CameraPicker(image: $avatarImage)
                }
                .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItems, matching: .images)
                .onChange(of: selectedItems) { oldItems, selectedItems in
                    images = []
                    for item in selectedItems {
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let imageData):
                                if let imageData, let uiImage = UIImage(data: imageData) {
                                    DispatchQueue.main.async {
                                        self.images.append(uiImage)
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
    
    private func removeBackground() {
        guard let image = avatarImage else { return }
        isProcessing = true 

        BackgroundRemover.shared.removeBackground(from: image) { processedImage in
            DispatchQueue.main.async {
                if let result = processedImage {
                    avatarImage = result
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

