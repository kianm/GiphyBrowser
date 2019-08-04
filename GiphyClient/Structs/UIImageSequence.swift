//
//  UIImageSequence.swift
//  GiphyClient
//
//  Created by kian on 6/10/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit

public struct UIImageSequence {

    public var images: [UIImage]
    typealias DataDict =  [Int: Data]
    public init(images: [UIImage]) {
        self.images = images
    }
    public enum CodingKeys: String, CodingKey {
        case dict
    }
}

extension UIImageSequence: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var imageDict: DataDict = [:]
        for index in 0..<images.count {
            guard let data = images[index].pngData() else {
                continue
            }
            imageDict[index] = data
        }
        try container.encode(imageDict, forKey: .dict)
    }
}

extension UIImageSequence: Decodable {

    public init(from decoder: Decoder) throws {
        images = []
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageDict: DataDict = try container.decode(DataDict.self, forKey: .dict)
        for (_, data) in imageDict {
            guard let image = UIImage(data: data) else {
                return
            }
            images.append(image)
        }
    }
}
