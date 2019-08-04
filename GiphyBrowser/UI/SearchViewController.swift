//
//  SearchViewController.swift
//  GiphyBrowser
//
//  Created by kian on 6/6/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit
import GiphyClient
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    private let bag = DisposeBag()
    private let searchButton = UIButton()
    private let searchField = UITextField()
    private var currentSearchText = ""
    private let bottomView = UIView()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private var bound = false
    private var listDelegate = PublishSubject<PluggableListDelegate>()
    private var numberPerRow = 2
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
        title = "Search"
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

extension SearchViewController: ViewModelBindable {
    var disposeBag: DisposeBag? {
        return self.bag
    }
    func bind(to viewModel: SearchViewModel) {
        let btnObservable = searchButton.rx.tap

        let textFieldObservable = btnObservable
            .map { [unowned self] in
                return self.searchField.text ?? "" }
            .filter { [unowned self] requestedSearchText in
                requestedSearchText != self.currentSearchText }
            .do(onNext: {[unowned self]  requestedSearchText in
                self.currentSearchText = requestedSearchText
            })

        btnObservable
            .subscribe(onNext: { [unowned self] _ in
                self.searchField.resignFirstResponder() })
            .disposed(by: bag)

        let scrollingReachedTheEnd = listDelegate
            .flatMap({ (delegate: PluggableListDelegate) -> Observable<Void> in
                if case PluggableListDelegate.scrollingReachedEnd = delegate {
                    return Observable.just(Void())
                } else {
                    return Observable.never()
                }
            })

        let cellSelected = listDelegate
            .flatMap({ (delegate: PluggableListDelegate) -> Observable<IndexPath> in
                if case let PluggableListDelegate.cellSelected(indexPath) = delegate {
                    return Observable.just(indexPath)
                } else {
                    return Observable.never()
                }
            })

        let input = SearchViewModel.Input(dataProvider: searchList.dataProvider,
                                           searchRequested: textFieldObservable,
                                          reachedEndOfTheList: scrollingReachedTheEnd,
                                          itemSelected: cellSelected)
        _ = viewModel.transform(input: input)
    }
}

extension SearchViewController {
    private func setupViews() {
        let safeView = UIView()
        view.addAndFitSubView(safeView, inSafeArea: true)
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        safeView.addSubview(topView)
        setupTopView(topView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        safeView.addSubview(bottomView)
        let views: [String: Any] = [
            "topView": topView,
            "bottomView": bottomView]
        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[topView]-0-|",
            metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[bottomView]-0-|",
            metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[topView]-0-[bottomView]-0-|",
            metrics: nil, views: views)
        safeView.addConstraints(constraints)
        bottomView.addAndFitSubView(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
    }
    private func setupTopView(_ view: UIView) {
        searchField.backgroundColor = UIScheme.textFieldColor
        searchButton.backgroundColor = UIScheme.buttonColor
        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.text = "apple"
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle("search", for: .normal)
        let views: [String: Any] = [
            "searchField": searchField,
            "searchButton": searchButton]
        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[searchField]-0-|",
            metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[searchButton]-0-|",
            metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-5-[searchField]-10-[searchButton]-10-|",
            metrics: nil, views: views)
        view.addConstraints(constraints)
    }
}
