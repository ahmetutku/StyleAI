//
//  ClosetItemImage.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 12.02.2025.
//


import SwiftUI

struct ClosetItemImage: Identifiable {
    var id = UUID()
    let closetImage: UIImage
    
    init(id:UUID, closetImage: UIImage){
        self.id = id
        self.closetImage = closetImage
    }
}
