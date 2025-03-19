//
//  DropdownMenuView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 29.01.2025.
//

import SwiftUI

struct DropdownMenuView: View {
    @Binding var isMenuOpen: Bool
    @Binding var selectedTab: String

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
                    menuItem(icon: "star.fill", title: "My Closet", tab: "Closet")
                    menuItem(icon: "magnifyingglass", title: "Create a Fit", tab: "Fit")
                    menuItem(icon: "flame", title: "My Fits", tab: "MyFits")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("background_color")))
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private func menuItem(icon: String, title: String, tab: String) -> some View {
        Button(action: {
            selectedTab = tab
            isMenuOpen = false
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                Text(title)
                    .foregroundColor(.accentColor)
            }
            .padding(.vertical, 5)
        }
    }
}

