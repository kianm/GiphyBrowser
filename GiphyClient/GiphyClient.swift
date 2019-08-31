//
//  GiphyClient.swift
//  GiphyClient
//
//  Created by kian on 6/8/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation
import RxSwift

public protocol GiphyClientType {
    func trendingGIFs(pageLimit: Int) -> Observable<SearchResult>
    func searchGIF(keyword: String, pageLimit: Int) -> Observable<SearchResult>
    func getNextPage() -> Observable<SearchResult>
    func retrieveImageSequence(path: String) -> Observable<UIImageSequence>
    func cancelImageRetrieve(path: String)
    func laodItem() -> GIF?
    func storeItem(gif: GIF)
}

public class GiphyClient: GiphyClientType, GCCacheInjected, ExecutorInjected {



    private(set) public var currentCount = 0
    private(set) public var totalCount = 0
    private(set) public var offset: Int = 0
    private let rating = "G"
    private var keyword = ""
    private var pageLimit: Int = 0
    private lazy var apiURL: String = Environment.variables.apiURL
    private lazy var apiKey: String = Environment.variables.apiKey
    private var operationIndexDict: [String: Int] = [:]
    private enum Mode {
        case trending
        case search
    }
    private var mode = Mode.search
    public var selectedItemStored: GIF?

    public func trendingGIFs(pageLimit: Int) -> Observable<SearchResult> {
        mode = .trending
//        gcCache.clearCache()
        self.pageLimit = pageLimit
        currentCount = 0
        totalCount = 0
        offset = 0
        return trendingGIFsInternal(pageLimit: pageLimit)
            .observeOn(MainScheduler.instance)
    }

    public func searchGIF(keyword: String, pageLimit: Int) -> Observable<SearchResult> {
        mode = .search
//        gcCache.clearCache()
        self.pageLimit = pageLimit
        currentCount = 0
        totalCount = 0
        offset = 0
        self.keyword = keyword
        return searchGIFInternal(keyword: keyword, pageLimit: pageLimit)
    }

    public func getNextPage() -> Observable<SearchResult> {
        offset = currentCount
        if offset < totalCount {
            switch mode {
            case .search:
                return searchGIFInternal(keyword: keyword, pageLimit: self.pageLimit)
            case .trending:
                return trendingGIFsInternal(pageLimit: self.pageLimit)
            }
        } else {
            return Observable.just(GCResult.success(GiphySearchResult()))
        }
    }

    public func retrieveImageSequence(path: String) -> Observable<UIImageSequence> {

        guard let url = URL(string: path) else {
            return Observable.just(placeHolderImageSequence)
        }

        let subject = ReplaySubject<UIImageSequence>.create(bufferSize: 1)
        let operationIndex = operationExecutor.enqueueFunction(getRequestSync, arg: url, subject: subject)
        operationIndexDict[path] = operationIndex
        return subject
    }

    public func cancelImageRetrieve(path: String) {
        guard let operationIndex = operationIndexDict[path] else {
            return
        }
        operationExecutor.cancelOperation(index: operationIndex)
    }

    private lazy var getRequestSync: (URL) -> UIImageSequence = { [weak self] url in
        self?.requestImageSync(url) ?? UIImageSequence(images: [])
    }

    private lazy var placeHolderImageSequence: UIImageSequence = {
        let imageURL = Bundle(for: type(of: self)).url(forResource: "earth4", withExtension: "gif")!
        return (try? Data(contentsOf: imageURL).imageSequence()) ?? Data().imageSequence()
    }()

    public func laodItem() -> GIF? {
        return selectedItemStored
    }

    public func storeItem(gif: GIF) {
        selectedItemStored = gif
    }

    public init() {
    }
}

// MARK: private methods
extension GiphyClient {

    private func trendingGIFsInternal(pageLimit: Int) -> Observable<SearchResult> {

        let result: Observable<SearchResult> =
            trendingGifs(limit: pageLimit, offset: offset)

        return result.map { (res: SearchResult) -> SearchResult in
            if res.wasSuccess {
                return self.handleSearchResult(res.value)
            } else {
                return self.handleSearchError(res.error)
            }
        }.observeOn(MainScheduler.instance)
    }

    private func searchGIFInternal(keyword: String, pageLimit: Int) -> Observable<SearchResult> {

        let result: Observable<SearchResult> =
            searchGifs(keyword: keyword, limit: pageLimit, offset: offset, rating: rating)

        return result.map { (res: SearchResult) -> SearchResult in
            if res.wasSuccess {
                return self.handleSearchResult(res.value)
            } else {
                return self.handleSearchError(res.error)
            }
        }.observeOn(MainScheduler.instance)
    }

    private func handleSearchResult(_ result: GiphySearchResult?) -> SearchResult {
        guard let result = result else {
            return GCResult.failure(GCErrorType.encodingError)
        }
        currentCount += result.pagination.count
        if totalCount == 0 {
            totalCount = result.pagination.total_count
        }
        return GCResult.success(result)
    }

    private func handleSearchError(_ error: Error?) -> SearchResult {
        guard let error = error else {
            return GCResult.failure(GCErrorType.encodingError)
        }

        return GCResult.failure(error)
    }

}

// MARK: API interactions

extension GiphyClient: APIInjected {

    private func trendingGifs(limit: Int, offset: Int) -> Observable<SearchResult> {
        var comps = URLComponents(string: apiURL)
        comps?.path += Environment.variables.trendingEndpoint
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                          URLQueryItem(name: "limit", value: "\(limit)"),
                          URLQueryItem(name: "offset", value: "\(offset)")]
        comps?.queryItems = queryItems
        guard let url = comps?.url else {
            return Observable.just(.failure(GCErrorType.badURL))
        }
        return apiClient.getDataASync(url)
            .map { [weak self] (result: GCResult<Data>) -> SearchResult in
                switch result {
                case .success(let data):
                    return self?.decoder(data: data) ?? GCResult.failure(GCErrorType.encodingError)
                case .failure(let error):
                    return .failure(error)
                }
        }
    }

    private func searchGifs(keyword: String, limit: Int, offset: Int, rating: String) -> Observable<SearchResult> {
        var comps = URLComponents(string: apiURL)
        comps?.path += Environment.variables.searchEndpoint
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                          URLQueryItem(name: "q", value: keyword),
                          URLQueryItem(name: "limit", value: "\(limit)"),
                          URLQueryItem(name: "offset", value: "\(offset)"),
                          URLQueryItem(name: "rating", value: "\(rating)"),
                          URLQueryItem(name: "lang", value: "en")]
        comps?.queryItems = queryItems
        guard let url = comps?.url else {
            return Observable.just(.failure(GCErrorType.badURL))
        }
        return apiClient.getDataASync(url)
            .map { [weak self] (result: GCResult<Data>) -> SearchResult in
                switch result {
                case .success(let data):
                    return self?.decoder(data: data) ?? GCResult.failure(GCErrorType.encodingError)
                case .failure(let error):
                    return .failure(error)
                }
        }
    }

    private func decoder(data: Data) -> SearchResult {

        if let result: GiphySearchResult = try? JSONDecoder().decode(GiphySearchResult.self, from: data) {
            return .success(result)
        } else {
            return .failure(GCErrorType.encodingError)
        }
    }

    private func requestImageSync(_ url: URL) -> UIImageSequence {
        let result = apiClient.getDataSync(url)
        switch result {
        case .success(let data):
            let imageSequence = data.imageSequence()
            self.gcCache.setImageSequence(key: url.path, images: imageSequence)
            return imageSequence
        case .failure:
            return UIImageSequence(images: [])
        }
    }
}
