//
//  MyFitView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 19.03.2025.
//

import SwiftUI

struct MyFitsView: View {
    @StateObject private var viewModel = MyFitViewModel()
    @Binding var selectedTab: String
    let columns = [GridItem(.adaptive(minimum: 120), spacing: 10)]
    private let categoryOrder: [String] = ["Outerwear", "Tops", "Bottoms", "Footwear"]
    
    var body: some View {
        NavigationView {
            ZStack{
                Color("background_color").ignoresSafeArea()
                VStack{
                    headerView
                    ScrollView {
                        savedFitsView
                    }
                    Spacer()
                }
            }
            .onAppear{
                viewModel.loadSavedFits()
            }
        }
    }
    private var headerView: some View {
        Text("My Fits")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .padding(.top, 10)
    }
    
    private var savedFitsView: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.savedFits.indices, id: \ .self) { index in
                VStack(alignment: .center) {
                    Text("Fit \(index + 1)")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack {
                            let sortedFit = viewModel.sortedFitItems(viewModel.savedFits[index])
                            ForEach(sortedFit, id: \ .self) { filename in
                                Image(uiImage: viewModel.loadImage(filename: filename))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
                .contextMenu {
                 Button(role: .destructive) {
                     viewModel.deleteFit(at: index)
                 } label: {
                  Label("Delete", systemImage: "trash")
                  }
                }
                .padding(.all, 10.0)
            }
        }
    }
}

struct MyFitsView_Previews: PreviewProvider {
    static var previews: some View {
        MyFitsView(selectedTab: .constant("MyFits"))
    }
}


