//
//  RootView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 21.01.2025.
//


import SwiftUI

struct RootView: View {
    @State private var showIntro = true // State variable to toggle between screens

    var body: some View {
        ZStack {
            if showIntro {
                IntroScreen(showIntro: $showIntro) // Show the intro screen first
            } else {
                ContentView() // Show the main screen
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
