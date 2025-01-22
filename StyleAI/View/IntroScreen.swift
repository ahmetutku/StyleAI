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
            Text("Welcome to My App")
                .font(.largeTitle)
                .padding()
            
            Text("An amazing app to make your life easier.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                showIntro = false // Change state to show the main screen
            }) {
                Text("Start")
                    .padding()
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
