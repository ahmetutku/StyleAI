//
//  IntroScreen.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 21.01.2025.
//


import SwiftUI

struct IntroScreen: View {
    @Binding var showIntro: Bool // Binding to control state from parent view
    
    var body: some View {
        VStack {
            Text("Welcome to StyleAI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
                .padding(.top)
            
            Text("StyleAI helps you dress better by learning your preferences and using ML and the information you provide to make your outfits the best outfits for you")
                .padding(.top)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
//                .foregroundColor(Color(.subtitle))
            
            Button(action: {
                showIntro = false // Change state to show the main screen
            }) {
                Text("Let's Get It")
                    .padding()
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

struct IntroScreen_Previews: PreviewProvider {
    static var previews: some View {
        IntroScreen(showIntro: .constant(true))
    }
}
