//
//  ListProtocols.swift
//  GiphyBrowser
//
//  Created by kian on 6/9/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit

public protocol Configurable {
    associatedtype Object
    func configure(object: Object, indexPath: IndexPath, tag: Int)
    func displayEnded()
}

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}

extension UICollectionView {
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
            else {
                fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
