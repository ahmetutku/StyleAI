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
            Spacer()
            Text("My Closet").font(.title2)
                .fontWeight(.bold).foregroundColor(.accentColor)
            Spacer()
            Button(action: {
            }) {
                Text("Add a Piece")
                    .padding()
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .background(Color(.accent))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 100.0)
            .foregroundColor(.accentColor)        }
        .background(Color("background_color").ignoresSafeArea())
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}
