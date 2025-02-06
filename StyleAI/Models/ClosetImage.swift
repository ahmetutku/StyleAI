//
//  ClosetImage.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 6.02.2025.
//
import SwiftUI

struct ClosetImage: Identifiable, Equatable {
    let id = UUID()
    var image: UIImage
    
    static func == (lhs: ClosetImage, rhs: ClosetImage) -> Bool {
        lhs.id == rhs.id
    }
}
