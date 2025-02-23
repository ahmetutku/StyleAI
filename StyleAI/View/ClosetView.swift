//
//  ClosetView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 30.01.2025.
//
import SwiftUI
import PhotosUI

import SwiftUI
import PhotosUI

struct ClosetView: View {
    @StateObject private var viewModel = ClosetViewModel()
    @State private var selectedImage: ClosetItemImage?
    @State private var menuPosition: CGPoint = .zero
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background_color").ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("My Closet")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(.accentColor)

                    Spacer()

                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.orderedCategories, id: \.self) { category in
                                if let items = viewModel.categorizedCloset[category] {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(category)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.accentColor)
                                        
                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                                            ForEach(items) { item in
                                                if let uiImage = item.closetImage {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(height: 100)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                        .shadow(radius: 5)
                                                        .onTapGesture {
                                                            selectedImage = item
                                                        }
                                                        .contextMenu {
                                                            Button(role: .destructive) {
                                                                viewModel.removeClosetItem(item)
                                                            } label: {
                                                                Label("Delete", systemImage: "trash")
                                                            }
                                                        }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }


                    Spacer()

                    Button(action: {
                        viewModel.showPhotoPicker.toggle()
                    }) {
                        Text("Add a Piece")
                            .padding()
                            .font(.title2)
                            .fontWeight(.bold)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .photosPicker(isPresented: $viewModel.showPhotoPicker, selection: $viewModel.closetItems, matching: .images)
                    .onChange(of: viewModel.closetItems) { newItems in
                        viewModel.addNewClosetImages(from: newItems)
                    }
                    .fullScreenCover(item: $selectedImage) { selectedImage in
                        FullScreenClosetImageView(originalImage: selectedImage.closetImage ?? UIImage(), onUpdate: { updatedImage in
                            viewModel.updateClosetItem(with: selectedImage.id, newImage: updatedImage)
                        })
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadClosetItems()
            }
            .alert("Item Not Recognized", isPresented: $viewModel.showUnrecognizedAlert, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text("This item could not be classified as clothing and was not added to your closet.")
            })
        }
    }

    
    private var menuButton: some View {
        GeometryReader { geometry in
            Button(action: {
                withAnimation {
                    viewModel.isMenuOpen.toggle()
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

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}
