//
//  FullScreenClosetImageView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 11.02.2025.
//


import SwiftUI

struct FullScreenClosetImageView: View {
    let imageName: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("background_color")
            Image(imageName)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    dismiss()
                }
        }.background(Color("background_color").ignoresSafeArea())
    }
}