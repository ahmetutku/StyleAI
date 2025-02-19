//
//  ClosetItemImage.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 12.02.2025.
//


import SwiftUI

struct ClosetItemImage: Identifiable, Codable {
    var id = UUID()
    let filename: String
    
    var closetImage: UIImage? {
           return ImageStorage.loadImage(named: filename)
       }
    
    init(id: UUID = UUID(), filename: String){
        self.id = id
        self.filename = filename
    }
}
