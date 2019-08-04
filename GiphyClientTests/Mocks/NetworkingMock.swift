//
//  NetworkingMock.swift
//  GiphyClientTests
//
//  Created by kian on 6/7/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation
@testable import GiphyClient

class NetworkingMock: NetworkingType {
    
    var calledWithURL: URLConvertible? = nil
    

    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> DataRequest {
        calledWithURL = url
        return DataRequest(session: URLSession(configuration: .default), requestTask: Request.RequestTask.data(nil,nil))
    }
    
}
