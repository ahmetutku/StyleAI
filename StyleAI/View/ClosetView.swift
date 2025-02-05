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

    var body: some View {
        ZStack {
            Color("background_color")
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
                }.confirmationDialog("Choose an Option", isPresented: $showingAlert, titleVisibility: .visible) {
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
                .photosPicker(isPresented: $showPhotoPicker, selection: $avatarItem, matching: .images)
                .onChange(of: avatarItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            removeBackground(from: uiImage)
                        }
                    }
                }
            }
        }
        .background(Color("background_color").ignoresSafeArea())
    }
    
    private func removeBackground(from image: UIImage) {
        BackgroundRemover.shared.removeBackground(from: image) { processedImage in
            if let result = processedImage {
                avatarImage = result
            }
        }
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}
