//
//  DataProvider.swift
//  GiphyBrowser
//
//  Created by kian on 6/9/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit
import GiphyClient

public protocol PlainRecord {
}

public protocol DataProvider: class {
    associatedtype Object
    func appendData(_ data: [Object])
    func clearData()
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object
    func numberOfItemsInSection(_ section: Int) -> Int
    func numberOfSections() -> Int
    func stringAtSection(_ section: Int) -> String
    func image(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void)
    func imageSequence(at indexPath: IndexPath, completion: @escaping (UIImageSequence) -> Void)
    func set(delegate: DataProviderDelegate)
    init()
}

extension DataProvider {

}

public protocol DataProviderDelegate: class {
    func dataProviderDidUpdate(_ updates: [DataProviderUpdate<PlainRecord>]?)
}

public enum DataProviderUpdate<T> {
    case insert([IndexPath])
    case delete([IndexPath])
    case update(IndexPath, T)
    case move(IndexPath, IndexPath)
    case insertSection(IndexSet)
    case reload
}
