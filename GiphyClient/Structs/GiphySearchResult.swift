//
//  GiphySearchResult.swift
//  GiphyBrowser
//
//  Created by kian on 6/6/19.
//  Copyright © 2019 Kian. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit
import RxSwift

public typealias SearchResult = GCResult<GiphySearchResult>

public struct GiphySearchResult: Decodable {
    public let data: [GIF]
    let pagination: Pagination
    internal init() {
        data = []
        pagination = Pagination()
    }
    internal init(pagination: Pagination) {
        data = []
        self.pagination = pagination
    }
}
struct Pagination: Decodable {
    let total_count: Int
    let count: Int
    let offset: Int
    init() {
        total_count = 0
        count = 0
        offset = 0
    }
    init(totalCount: Int, count: Int, offset: Int) {
        self.total_count = totalCount
        self.count = count
        self.offset = offset
    }
}

public struct FixedWidth: Decodable {
    public let url: String
    public let mp4: String
    public let webp: String
}

public struct Images: Decodable {
    public let fixed_width: FixedWidth
}

public struct GIF: Decodable {

    public enum CodingKeys: String, CodingKey {
        case title
        case type
        case id
        case images
    }
    public let title: String
    let type: String
    let id: String
    public let images: Images
    public var imageSequenceRetriever: ((IndexPath, @escaping (UIImageSequence) -> Void) -> Void)?
    public var imageSequence: UIImageSequence?
}
