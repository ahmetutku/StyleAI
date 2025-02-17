//
//  FullScreenClosetImageView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 11.02.2025.
//


import SwiftUI

struct FullScreenClosetImageView: View {
    let image: UIImage
    @Environment(\.dismiss) var dismiss
    @State private var isProcessing = false
//    let removeBackground: (UIImage) -> Void

    var body: some View {
        ZStack {
            
            Color("background_color")
            VStack{
                Image(uiImage: image).resizable()
                    .scaledToFit()
                    .onTapGesture {
                        dismiss()
                    }
                
                Button(action: {
                    //removeBackground(image)
                    
                }) {
                    if isProcessing {
                        ProgressView()
                    } else {
                        Text("Remove Background")
                            .padding()
                            .font(.title2)
                            .fontWeight(.bold)
                            .background(.accent)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }.background(Color("background_color").ignoresSafeArea())
    }
}
