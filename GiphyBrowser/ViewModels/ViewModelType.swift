//
//  ViewModelType.swift
//  GiphyBrowser
//
//  Created by kian on 6/8/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

protocol ViewModelBindable {

    associatedtype ViewModel: ViewModelType

    var disposeBag: DisposeBag? { get }
    func bind(to viewModel: ViewModel)
}
