//
//  RootView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 21.01.2025.
//


import SwiftUI

struct RootView: View {
    @State private var showIntro = true
    @StateObject private var viewModel = ClosetViewModel()

    var body: some View {
        ZStack {
            Color("background_color").ignoresSafeArea()
            
            if (showIntro && viewModel.images.isEmpty) {
                IntroScreen(showIntro: $showIntro)
            } else {
                ClosetView()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
