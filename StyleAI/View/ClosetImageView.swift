//
//  ClosetImageView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 6.02.2025.
//
import SwiftUI

struct ClosetImageViewClosetImageView: View {
    let image: UIImage
    let removeBackground: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isProcessing = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(radius: 5)

                Button(action: {
                    isProcessing = true
                    removeBackground(image)
                    isProcessing = false
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
                .padding()

                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .foregroundColor(.white)
            }
        }
    }
}
