//
//  FullScreenClosetImageView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 11.02.2025.
//


import SwiftUI

struct FullScreenClosetImageView: View {
    let originalImage: UIImage
    @Environment(\.dismiss) var dismiss
    @State private var processedImage: UIImage?
    @State private var isProcessing = false

    var body: some View {
        ZStack {
            Color("background_color").ignoresSafeArea()

            VStack {
                Image(uiImage: processedImage ?? originalImage)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        dismiss()
                    }

                Button(action: removeBackground) {
                    if isProcessing {
                        ProgressView()
                    } else {
                        Text("Remove Background")
                            .padding()
                            .font(.title2)
                            .fontWeight(.bold)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .disabled(isProcessing)
            }
        }
    }

    private func removeBackground() {
        isProcessing = true

        BackgroundRemover.shared.removeBackground(from: originalImage) { result in
            DispatchQueue.main.async {
                processedImage = result ?? originalImage
                isProcessing = false
            }
        }
    }
}
