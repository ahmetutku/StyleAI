//
//  BackgroundRemover.swift
//  StyleAI
//
//  Created by Ahmet Hamamcioglu on 2.02.2025.
//
import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

final class BackgroundRemover {
    
    static let shared = BackgroundRemover()
    private let context = CIContext()
    
    private init() {}
    
    func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            print("Failed to create CIImage")
            completion(nil)
            return
        }
        
        Task {
            guard let maskImage = createMask(from: ciImage) else {
                print("Failed to create mask")
                completion(nil)
                return
            }
            
            let outputImage = applyMask(mask: maskImage, to: ciImage)
            let finalImage = convertToUIImage(ciImage: outputImage)
            
            DispatchQueue.main.async {
                completion(finalImage)
            }
        }
    }
    
    private func createMask(from inputImage: CIImage) -> CIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(ciImage: inputImage)
        
        do {
            try handler.perform([request])
            
            if let result = request.results?.first {
                let mask = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
                return CIImage(cvPixelBuffer: mask)
            }
        } catch {
            print("Mask generation error: \(error)")
        }
        
        return nil
    }
    
    private func applyMask(mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        
        return filter.outputImage ?? image
    }
    
    private func convertToUIImage(ciImage: CIImage) -> UIImage? {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            print("Failed to render CGImage")
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
