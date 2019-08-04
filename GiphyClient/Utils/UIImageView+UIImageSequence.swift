//
//  UIImageView+UIImageSequence.swift
//  GiphyClient
//
//  Created by kian on 8/4/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit

public extension UIImageView {
    func animateImage(imageSequence: UIImageSequence, fpsInverse: Double) {
        animationDuration = fpsInverse * Double(imageSequence.images.count)
        animationImages = imageSequence.images
        startAnimating()
    }
}
