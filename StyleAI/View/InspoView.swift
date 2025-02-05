//
//  InspoView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 3.02.2025.
//

import SwiftUI

struct InspoView: View {
    var numberOfOutfits: Int = 11
    let outfitImages: [String]

    init() {
        self.outfitImages = (1...numberOfOutfits).map { "outfit\($0)" }
        }

    var body: some View {
        ZStack {
            Color("background_color").ignoresSafeArea()
            VStack{
                Text("Here's Whats Trending")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(.accentColor)
                ScrollView{
                    VStack{
                        ForEach(outfitImages, id: \.self) { imageName in
                                                  Image(imageName) // Directly loads from Assets
                                                      .resizable()
                                                      .scaledToFit()
                                                      .frame(width: 150, height: 200)
                                                      .cornerRadius(10)
                                                      .shadow(radius: 5)
                                              }
                    }
                }
            }

        }.background(Color("background_color").ignoresSafeArea())

    }
}

struct InspoView_Previews: PreviewProvider {
    static var previews: some View {
        InspoView()
    }
}
