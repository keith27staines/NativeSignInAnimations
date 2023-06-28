//
//  GIFLoaderImageView.swift
//  NativeSignInAnimations
//
//  Created by Sohel Dhengre on 28/06/2023.
//

import UIKit

extension UIImage {
    
    class func imagesFromGIFData(_ data: Data) -> [UIImage] {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil)
        else { return [] }
        
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil)
            else { continue }
            images.append(UIImage(cgImage: cgImage))
        }
        
        return images
    }
}
