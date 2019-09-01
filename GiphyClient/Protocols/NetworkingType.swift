//
//  NetworkingType.swift
//  GiphyClient
//
//  Created by kian on 6/7/19.
//  Copyright © 2019 Kian. All rights reserved.
//

    import RxSwift

    protocol NetworkingType {

        func dataTask(with request: URLRequest,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

    }

    extension URLSession: NetworkingType {
    }

    func configuration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        configuration.urlCache?.memoryCapacity = 0
        configuration.urlCache?.diskCapacity = 0
        return configuration
    }

    extension NetworkingType {

        func syncDataTask(urlrequest: URLRequest) -> GCResult<Data> {
            var data: Data?
            var error: Error?

            let semaphore = DispatchSemaphore(value: 0)

            let dataTask = self.dataTask(with: urlrequest) {
                data = $0
                error = $2
                semaphore.signal()
            }
            dataTask.resume()

            _ = semaphore.wait(timeout: .distantFuture)

            if let error = error {
                return .failure(error)
            }
            if let data = data {
                return .success(data)
            }
            return .success(Data())
        }

        func asyncDataTask(urlrequest: URLRequest) -> Observable<GCResult<Data>> {

            let subject = PublishSubject<GCResult<Data>>()
            let dataTask = self.dataTask(with: urlrequest) {
                if let error = $2 {
                    subject.onNext(GCResult<Data>.failure(error))
                }
                if let data = $0 {
                    subject.onNext(GCResult<Data>.success(data))
                }
            }
            dataTask.resume()
            return subject
        }
    }
