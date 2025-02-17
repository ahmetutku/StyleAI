//
//  ContentView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 20.01.2025.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var isMenuOpen: Bool = false
    @State var selectedItems: [PhotosPickerItem] = []
    @State var images: [UIImage] = []
    @State private var menuPosition: CGPoint = .zero

    
    var body: some View {
        NavigationView{
            
            ZStack{
                Color("background_color").ignoresSafeArea()

                if isMenuOpen {
                    DropdownMenuView(
                        isMenuOpen: $isMenuOpen
                    ).padding(.top, -60.0)
                }
                
                VStack(spacing: 30) {
                    Image(systemName: "lock.circle")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundColor(Color("subtitle_color"))
                    
                    Text("What Would You Like to Dress Like Today")
                        .foregroundColor(.accentColor)
                        .fontWeight(.bold)
                    
                    PhotosPicker(selection: $selectedItems, matching: .images) {
                        Text("Select Today's Fit Inspo")
                    }.foregroundColor(Color("subtitle_color"))
                        .fontWeight(.bold)
                    Button(action: {

                    }) {
                        Text("Suprise Me")
                            .padding()
                            .font(.title2)
                            .fontWeight(.bold)
                            .background(.accent)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color("background_color").ignoresSafeArea())
            .navigationBarItems(leading: menuButton)
            .navigationBarTitleDisplayMode(.inline)
        }
        

    }
    private var menuButton: some View {
        GeometryReader { geometry in
            Button(action: {
                withAnimation {
                    isMenuOpen.toggle()
                    menuPosition = CGPoint(
                        x: geometry.frame(in: .global).minX + 20,
                        y: geometry.frame(in: .global).maxY + 10
                    )
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
        }
        .frame(width: 44, height: 44)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
