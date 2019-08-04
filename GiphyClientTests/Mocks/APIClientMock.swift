//
//  APIClientMock.swift
//  GiphyClientTests
//
//  Created by kian on 6/10/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import RxSwift
@testable import GiphyClient

class APIClientMock: APIType {
    
    func getDataSync(_ url: URL) -> GCResult<Data> {
        return .success(Data())
    }
    
    func getDataASync(_ url: URL) -> Observable<GCResult<Data>> {
        return Observable.just(.success(Data()))
    }

}
