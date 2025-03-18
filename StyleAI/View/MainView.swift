//
//  MainView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 18.03.2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = "Closet"
    @State private var isMenuOpen = false

    var body: some View {
        ZStack {
            Color("background_color").ignoresSafeArea()

            TabView(selection: $selectedTab) {
                ClosetView(selectedTab: $selectedTab)
                    .tag("Closet")
                FitView(selectedTab: $selectedTab)
                    .tag("Fit")
                InspoView(selectedTab: $selectedTab)
                    .tag("Inspo")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Optional styling

            menuButton
                .position(x: 30, y: 45)
                .zIndex(2)

            if isMenuOpen {
                DropdownMenuView(isMenuOpen: $isMenuOpen, selectedTab: $selectedTab)
                    .position(x: 100, y: 100)
                    .zIndex(1)
            }
        }
    }

    private var menuButton: some View {
        Button(action: { withAnimation { isMenuOpen.toggle() } }) {
            Image(systemName: "line.horizontal.3")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding()
        }
    }
}
