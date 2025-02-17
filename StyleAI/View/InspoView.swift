//
//  InspoView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 3.02.2025.
//

import SwiftUI

struct InspoView: View {
    var numberOfOutfits: Int = 11
    let outfitImages: [OutfitImage]
    
    @State private var selectedImage: OutfitImage?
    
    init() {
        self.outfitImages = (1...numberOfOutfits).map { OutfitImage(name: "outfit\($0)") }
    }

    var body: some View {
        ZStack {
            Color("background_color").ignoresSafeArea()
            
            VStack {
                Text("Here's What's Trending")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(.accentColor)
                
                ScrollView {
                    let columns = [GridItem(.adaptive(minimum: 120), spacing: 10)]
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(outfitImages) { outfit in
                            Image(outfit.name)
                                .resizable()
                                .scaledToFill()
                                .frame(height: CGFloat.random(in: 200...250))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 10)
                                .onTapGesture {
                                    selectedImage = outfit
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .fullScreenCover(item: $selectedImage) { outfit in
            FullScreenInspoView(imageName: outfit.name)
        }
    }
}

struct InspoView_Previews: PreviewProvider {
    static var previews: some View {
        InspoView()
    }
}
