//
//  SearchResultDataProvider.swift
//  GiphyBrowser
//
//  Created by kian on 6/9/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation
import GiphyClient

class SearchResultDataProvider: DataProvider {


    typealias Object = GIF
    private var data: [GIF] = []
    private weak var delegate: DataProviderDelegate?
    public var imageSequenceRetriever: ((IndexPath, @escaping (UIImageSequence) -> Void) -> Void)?

    required init() {
    }

    func appendData(_ data: [Object]) {

        let dataToAdd = (data.count == 0) ? self.data : data // there's no more data, duplicate existing data
        var indexPathsToInsert: [IndexPath] = []
        let currentCount = self.data.count
        for row in currentCount ..< currentCount + dataToAdd.count {
            indexPathsToInsert.append(IndexPath(row: row, section: 0))
        }
        let dataProviderUpdates: [DataProviderUpdate<PlainRecord>] = [.insert(indexPathsToInsert)]
        for gif in dataToAdd {
            var gifMod = gif
            gifMod.imageSequenceRetriever = self.imageSequence
            self.data.append(gifMod)
        }
        delegate?.dataProviderDidUpdate(dataProviderUpdates)
    }

    func clearData() {
        var indexPathsToDelete: [IndexPath] = []
        for row in 0 ..< data.count {
            indexPathsToDelete.append(IndexPath(row: row, section: 0))
        }
        let dataProviderUpdates: [DataProviderUpdate<PlainRecord>] = [.delete(indexPathsToDelete)]
        data.removeAll()
        delegate?.dataProviderDidUpdate(dataProviderUpdates)
    }

    public func set(delegate: DataProviderDelegate) {
        self.delegate = delegate
    }

    func stringAtSection(_ section: Int) -> String {
        return ""
    }

    public func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        let index = indexPath.row //% data.count
        return data[index]
    }

    public func numberOfItemsInSection(_ section: Int) -> Int {
        return data.count
    }

    public func numberOfSections() -> Int {
        return 1
    }

    public func image(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
    }

    func imageSequence(at indexPath: IndexPath, completion: @escaping (UIImageSequence) -> Void) {
        imageSequenceRetriever?(indexPath, completion)
    }

}
