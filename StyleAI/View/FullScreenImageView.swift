//
//  FullScreenImageView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 4.02.2025.
//
import SwiftUI

struct FullScreenImageView: View {
    let imageName: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("background_color")
            Image(imageName)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    dismiss() // Close full-screen image on tap
                }
        }.background(Color("background_color").ignoresSafeArea())
    }
}
