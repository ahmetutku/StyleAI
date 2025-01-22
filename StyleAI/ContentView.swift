//
//  ContentView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 20.01.2025.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State var selectedItems: [PhotosPickerItem] = []
    @State var images: [UIImage] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, welcome to StyleAI!")
            
            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
            avatarImage?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            PhotosPicker(selection: $selectedItems, matching: .images) {
                Text("Select Multiple Photos")
            }
            .onChange(of: selectedItems) { selectedItems in
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
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .onChange(of: avatarItem) { _ in
            Task {
                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                    avatarImage = loaded
                } else {
                    print("Failed")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
