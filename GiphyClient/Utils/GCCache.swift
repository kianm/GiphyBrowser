//
//  GCCache.swift
//  GiphyClient
//
//  Created by kian on 6/10/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit
import RxSwift
import KMOperation

class GCCache: GCCacheType {

    private var memCache: [String: UIImageSequence] = [:]
    private let accessQueue = DispatchQueue(label: "GCCacheDictAccess", attributes: .concurrent)

    func clearCache() {

        guard let fileURLs = try? FileManager.default.contentsOfDirectory(at: rootURL,
                                                                          includingPropertiesForKeys: nil,
                                                                          options: [])
            else {
                return
        }
        for fileURL in fileURLs {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }

    func setImageSequence(key: String, images: UIImageSequence) {

        guard let data = try? PropertyListEncoder().encode(images) else {
            return
        }

        NSKeyedArchiver.archiveRootObject(data, toFile: path(key))
        self.accessQueue.async(flags: .barrier) {
            self.memCache[key] = images
        }
    }

    func getImageSequence(key: String) -> Observable<UIImageSequence?> {

        return Observable<UIImageSequence?>.create { [unowned self] (observer: AnyObserver<UIImageSequence?>) -> Disposable in
            observer.onNext(self.getImageSequence(key: key))
            return Disposables.create()
        }
    }

    private func getImageSequence(key: String) -> UIImageSequence? {
        var sequence: UIImageSequence?
        self.accessQueue.sync {
            sequence = self.memCache[key]
        }
        if let sequence = sequence {
            return sequence
        }
        let data = NSKeyedUnarchiver.unarchiveObject(withFile: self.path(key)) as? Data
        if let data = data {
            sequence = try? PropertyListDecoder().decode(UIImageSequence.self, from: data)
        }
        if let sequence = sequence {
            self.accessQueue.async(flags: .barrier) {
                self.memCache[key] = sequence
            }
        }
        return nil
    }

    private func path(_ key: String) -> String {
        let keyFlattened = key.replacingOccurrences(of: "/", with: "_")
        return rootURL.appendingPathComponent(keyFlattened).path
    }

    private lazy var rootURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = paths.first else {
            fatalError("could not get documents directory!")
        }
        let urlCache = url.appendingPathComponent("cache")
        try? FileManager.default.createDirectory(atPath: urlCache.path,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
        return urlCache
    }()
}
