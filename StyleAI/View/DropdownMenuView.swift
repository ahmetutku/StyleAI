//
//  DropdownMenuView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 29.01.2025.
//


//
//  DropdownMenuView.swift
//  pnc
//
//  Created by Ahmet Hamamcioglu on 9.12.2024.
//

import SwiftUI
struct DropdownMenuView: View {
    @Binding var isMenuOpen: Bool


    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
                .onTapGesture {
                    isMenuOpen = false
                }

            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button(action: { isMenuOpen = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                }
                .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    NavigationLink(destination: Text("Placeholder Destination")) {
                        menuItem(icon: "magnifyingglass", title: "Inspo")
                    }
                    NavigationLink(destination: ClosetView()) {
                        menuItem(icon: "star.fill", title: "My Closet")
                    }
                    menuItem(icon: "flame", title: "Popular")
                }
                .padding()
                
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("background_color")))
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private func menuItem(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            Text(title)
                .foregroundColor(.accentColor)
        }
        .padding(.vertical, 5)
        
    }
}
