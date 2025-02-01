//
//  ClosetView.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 30.01.2025.
//
import SwiftUI
import PhotosUI


struct ClosetView: View {
    @State private var showPhotoPicker = false
    @State private var showingAlert = false
    @State private var avatarImage: Image?
    @State private var avatarItem: PhotosPickerItem?

    var body: some View {
        ZStack{
            Color("background_color")
            VStack(spacing: 20){
                Text("My Closet")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.top)
                                    .foregroundColor(.accentColor)

                Spacer()
                
                Button(action: {
                    showingAlert = true

                }) {
                    Text("Add a Piece")
                        .padding()
                        .font(.title2)
                        .fontWeight(.bold)
                        .background(Color(.accent))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }.confirmationDialog("Choose an Option", isPresented: $showingAlert, titleVisibility: .visible) {
                    Button("Take a Picture") {
                        print("Camera selected")
                    }
                    Button("Choose from Library") {
                        showPhotoPicker = true
                    }
                }
                // PhotosPicker shown separately
                .photosPicker(isPresented: $showPhotoPicker, selection: $avatarItem, matching: .images)
                .onChange(of: avatarItem) { oldItem, newItem in
                    Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            avatarImage = Image(uiImage: uiImage)
                            }
                        }
                    }
                }
                .foregroundColor(.accentColor)
                
            }

        }.background(Color("background_color").ignoresSafeArea())
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}
