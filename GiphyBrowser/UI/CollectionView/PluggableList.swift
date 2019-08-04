//
//  PluggableList.swift
//  GiphyBrowser
//
//  Created by kian on 6/9/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit
import RxSwift

public enum PluggableListDelegate {
    case scrollingReachedEnd
    case cellSelected(IndexPath)
}

public class PluggableList<CustomCell: UICollectionViewCell, CellData: DataProvider>: NSObject,
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout where
CustomCell: Reusable, CustomCell: Configurable, CustomCell.Object == CellData.Object {

    private(set) public var dataProvider: CellData!
    private weak var collectionView: UICollectionView!
    private var cellSize: CGSize!
    private weak var delegate: PublishSubject<PluggableListDelegate>?

    public init(collectionView: UICollectionView, cellSize: CGSize, delegate: PublishSubject<PluggableListDelegate>) {
        super.init()
        self.collectionView = collectionView
        self.cellSize = cellSize
        self.delegate = delegate
        setupCollectionView()
        self.dataProvider = CellData()
        self.dataProvider.set(delegate: self)
    }
    // MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as CustomCell
            self.configure(cell: cell, indexPath: indexPath)
            return cell
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataProvider.numberOfSections()
    }
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                               forItemAt indexPath: IndexPath) {
        let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        if indexPath.row == count - 1 {
            delegate?.on(.next(.scrollingReachedEnd))
        }
    }
    public func collectionView(_ collectionView: UICollectionView,
                               didEndDisplaying cell: UICollectionViewCell,
                               forItemAt indexPath: IndexPath) {
        guard let customCell = cell as? CustomCell else {
            return
        }
        customCell.displayEnded()
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.reloadItems(at: [indexPath])
        delegate?.on(.next(.cellSelected(indexPath)))
    }
}

// MARK: - Cell addition/removal

extension PluggableList: DataProviderDelegate {
    public func dataProviderDidUpdate(_ updates: [DataProviderUpdate<PlainRecord>]?) {
        guard let updates = updates else {
            return
        }
        let updateOperations: () -> Void = { [unowned self] in
            for update in updates {
                switch update {
                case .insert(let indexPaths):
                    self.collectionView.insertItems(at: indexPaths)
                case .delete(let indexPaths):
                    self.collectionView.deleteItems(at: indexPaths)
                default:
                    break
                }
            }
        }
        collectionView.performBatchUpdates(updateOperations, completion: nil)
    }
}

// MARK: - Cell configuration

extension PluggableList {
    func configure(cell: CustomCell, indexPath: IndexPath) {
        let tag = indexPath.row
        cell.configure(object: dataProvider.objectAtIndexPath(indexPath), indexPath: indexPath, tag: tag)
    }
}
// MARK: - UICollectionView Setup
extension PluggableList {
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(CustomCell.self)
    }
}
