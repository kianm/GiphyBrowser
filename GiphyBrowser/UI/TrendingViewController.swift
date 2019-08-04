//
//  TrendingViewController.swift
//  GiphyBrowser
//
//  Created by kian on 7/7/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit
import GiphyClient
import RxSwift

class TrendingViewController: UIViewController {
    private let viewModel = TrendingViewModel()
    private let bag = DisposeBag()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private var bound = false
    private var listDelegate = PublishSubject<PluggableListDelegate>()
    private var numberPerRow = 7
    private lazy var layout: UICollectionViewFlowLayout = {
        return UICollectionViewFlowLayout()
    }()

    private lazy var cellSize: CGSize = {
        let totalSpace = layout.sectionInset.left + layout.sectionInset.right
            + (layout.minimumInteritemSpacing * CGFloat(numberPerRow - 1))
        let width = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberPerRow))
        let height = Int(1.28 * Double(width))
        return CGSize(width: width, height: height)
    }()

    private lazy var searchList =
        PluggableList<SearchCell, SearchResultDataProvider>(collectionView: collectionView,
                                                            cellSize: cellSize,
                                                            delegate: listDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trending"
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !bound {
            bound = true
            bind(to: viewModel)
        }
    }
}

extension TrendingViewController: ViewModelBindable {
    var disposeBag: DisposeBag? {
        return self.bag
    }
    func bind(to viewModel: TrendingViewModel) {

        let cellSelected = listDelegate
            .flatMap{ [unowned self] (delegate: PluggableListDelegate) -> Observable<IndexPath> in
                if case let PluggableListDelegate.cellSelected(indexPath) = delegate {
                    return Observable.just(indexPath)
                } else {
                    return Observable.never()
                }
            }

        let input = TrendingViewModel.Input(dataProvider: searchList.dataProvider,
                                          itemSelected: cellSelected)
        _ = viewModel.transform(input: input)
    }
}

extension TrendingViewController {
    private func setupViews() {
        view.addAndFitSubView(collectionView, inSafeArea: true)
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
    }
}
