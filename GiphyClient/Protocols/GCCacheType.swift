//
//  GCCacheType.swift
//  GiphyClient
//
//  Created by kian on 6/10/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation
import RxSwift

protocol GCCacheType {
    func setImageSequence(key: String, images: UIImageSequence)
    func getImageSequence(key: String) -> Observable<UIImageSequence?>
    func clearCache()
}
