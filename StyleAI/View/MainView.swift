//
//  MainView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 18.03.2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: String = "Closet"
    @State private var isMenuOpen: Bool = false

    var body: some View {
        ZStack {
            Color("background_color").ignoresSafeArea()

            switch selectedTab {
            case "Closet":
                ClosetView(selectedTab: $selectedTab)
            case "Fit":
                FitView(selectedTab: $selectedTab)
            case "Inspo":
                InspoView()
            default:
                ClosetView(selectedTab: $selectedTab)
            }

            menuButton
                .position(x: 30, y: 35)
                .zIndex(1)

            if isMenuOpen {
                DropdownMenuView(isMenuOpen: $isMenuOpen, selectedTab: $selectedTab)
            }
        }
    }

    private var menuButton: some View {
        Button(action: {
            withAnimation {
                isMenuOpen.toggle()
            }
        }) {
            Image(systemName: "line.horizontal.3")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding()
        }
    }
}
