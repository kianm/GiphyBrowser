//
//  Data+UIImage.swift
//  GiphyClient
//
//  Created by kian on 6/10/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit

extension Data {

    func imageSequence() -> UIImageSequence {
            var images = [UIImage]()
            guard let source =  CGImageSourceCreateWithData(self as CFData, nil) else {
                return UIImageSequence(images: images)
            }
            let imageCount = CGImageSourceGetCount(source)
            for imageIndex in 0 ..< imageCount {
                if let image = CGImageSourceCreateImageAtIndex(source, imageIndex, nil) {
                    images.append(UIImage(cgImage: image))
                }
            }
            return UIImageSequence(images: images)
    }
}
