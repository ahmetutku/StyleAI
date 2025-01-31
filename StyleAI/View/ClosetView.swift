//
//  ClosetView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 30.01.2025.
//
import SwiftUI

struct ClosetView: View {
    var body: some View {
        ZStack{
            Color("background_color")
            VStack(spacing: 20){
                Text("My Closet")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.top)
                                    .foregroundColor(.accentColor)

                Spacer()
                Button(action: {
                }) {
                    Text("Add a Piece")
                        .padding()
                        .font(.title2)
                        .fontWeight(.bold)
                        .background(Color(.accent))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .foregroundColor(.accentColor)
            }

        }.background(Color("background_color").ignoresSafeArea())
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}
