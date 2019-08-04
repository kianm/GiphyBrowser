//
//  Injectables.swift
//  GiphyBrowser
//
//  Created by kian on 6/6/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation
import KMOperation

struct InjectionMaps {
    static let networking: NetworkingType = URLSession(configuration: configuration())
    static let apiClient: APIType = APIClient()
    static let giphyClient: GiphyClientType = GiphyClient()
    static let giphyCache: GCCacheType = GCCache()
    static let operationExecutor: KMOperationExecutorType = KMOperationExecutor()
}

protocol NetworkingInjected {}
extension NetworkingInjected {
    var networking: NetworkingType { return InjectionMaps.networking}
}

protocol APIInjected {}
extension APIInjected {
    public var apiClient: APIType { return InjectionMaps.apiClient}
}

protocol GiphyClientInjected {}
extension GiphyClientInjected {
    public var giphyClient: GiphyClientType { return InjectionMaps.giphyClient}
}

protocol GCCacheInjected {}
extension GCCacheInjected {
    public var gcCache: GCCacheType { return InjectionMaps.giphyCache}
}

protocol ExecutorInjected {}
extension ExecutorInjected {
    var operationExecutor: KMOperationExecutorType { return InjectionMaps.operationExecutor}
}
