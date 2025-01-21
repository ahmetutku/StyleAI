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
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, welcome to StyleAI!")
            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)

                        avatarImage?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
        }
        .padding()
        .onChange(of: avatarItem) {
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

#Preview {
    ContentView()
}
