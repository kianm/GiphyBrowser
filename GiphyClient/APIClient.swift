//
//  APIClient.swift
//  GiphyBrowser
//
//  Created by kian on 6/6/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import RxSwift
import KMOperation

public final class APIClient: APIType, NetworkingInjected {

    internal func getDataASync(_ url: URL) -> Observable<GCResult<Data>> {
        return networking.asyncDataTask(urlrequest: request(url))
    }

    internal func getDataSync(_ url: URL) -> GCResult<Data> {
        return networking.syncDataTask(urlrequest: request(url))
    }

    private func request(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers()
        return request
    }

    private func headers() -> [String: String] {
        return [
            "User-Agent": "GiphyBrowser iOS v1.0",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": "en",
            "Accept-Encoding": ""
        ]
    }

    internal init() {

    }
}
