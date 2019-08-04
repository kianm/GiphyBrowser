//
//  GiphyAPIType.swift
//  GiphyClient
//
//  Created by kian on 6/10/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import RxSwift

protocol APIType: class {
    func getDataSync(_ url: URL) -> GCResult<Data>
    func getDataASync(_ url: URL) -> Observable<GCResult<Data>>
}
