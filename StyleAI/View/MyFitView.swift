//
//  MyFitView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 19.03.2025.
//

import SwiftUI

struct MyFitsView: View {
    @Binding var selectedTab: String
    @State private var savedFits: [[String: String]] = []

    var body: some View {
        NavigationView {
            ZStack{
                Color("background_color").ignoresSafeArea()
                VStack{
                    headerView
                    savedFitsView
                    Spacer()
                }
            }
            .onAppear(perform: loadSavedFits)
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
        VStack {
            ForEach(savedFits.indices, id: \ .self) { index in
                VStack(alignment: .leading) {
                    Text("Fit \(index + 1)")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(savedFits[index].values), id: \ .self) { filename in
                                Image(uiImage: loadImage(filename: filename))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
    private func loadSavedFits() {
        savedFits = UserDefaults.standard.array(forKey: "savedFits") as? [[String: String]] ?? []
    }

    private func loadImage(filename: String) -> UIImage {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentDirectory = paths.first {
            let fileURL = documentDirectory.appendingPathComponent(filename)
            if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                return image
            }
        }
        return UIImage(systemName: "photo") ?? UIImage()
    }
}

struct MyFitsView_Previews: PreviewProvider {
    static var previews: some View {
        MyFitsView(selectedTab: .constant("MyFits"))
    }
}


