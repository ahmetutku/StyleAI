//
//  ClosetView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 30.01.2025.
//
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
                    headerView
                    closetScrollView
                    addPieceButton
                }
                .onAppear { viewModel.loadClosetItems() }

                menuButton
                    .position(x: 30, y: 45)

                if viewModel.isMenuOpen {
                    DropdownMenuView(isMenuOpen: $viewModel.isMenuOpen)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { viewModel.loadClosetItems() }
            .fullScreenCover(isPresented: $viewModel.showFullScreenSelection) {
                if let tempImage = viewModel.tempImage {
                    FullScreenImageSelectionView(viewModel: viewModel, image: tempImage)
                }
            }
            .fullScreenCover(item: $selectedImage) { selectedImage in
                FullScreenClosetImageView(
                    originalImage: selectedImage.closetImage ?? UIImage(),
                    onUpdate: { updatedImage in
                        viewModel.updateClosetItem(with: selectedImage.id, newImage: updatedImage)
                    }
                )
            }
        }
    }

    private var headerView: some View {
        Text("My Closet")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .padding(.top, 10)
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

    private var closetScrollView: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.orderedCategories, id: \.self) { category in
                    if let items = viewModel.categorizedCloset[category] {
                        closetCategoryView(category: category, items: items)
                    }
                }
            }
        }
    }

    private func closetCategoryView(category: String, items: [ClosetItemImage]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(category)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                ForEach(items) { item in
                    closetItemView(item: item)
                }
            }
        }
        .padding(.horizontal)
    }

    private func closetItemView(item: ClosetItemImage) -> some View {
        Group {
            if let uiImage = item.closetImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .onTapGesture { selectedImage = item }
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

    private var addPieceButton: some View {
        Button(action: { viewModel.showPhotoPicker.toggle() }) {
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
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}


