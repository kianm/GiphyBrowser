//
//  TrendingViewModel.swift
//  GiphyBrowser
//
//  Created by kian on 6/8/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import GiphyClient
import RxSwift

final class TrendingViewModel: ViewModelType, InteractionInjected, GiphyClientInjected {
    private let bag = DisposeBag()
    private var dataProvider: SearchResultDataProvider!
    private let numberOfPages = 20
    private let numberPerPage = 25
    // swiftlint:disable weak_delegate
    struct Input {
        let dataProvider: SearchResultDataProvider
        let itemSelected: Observable<IndexPath>
    }
    // swiftlint:enable weak_delegate
    struct Output {
    }

    private func imageSequence(at indexPath: IndexPath, completion: @escaping (UIImageSequence) -> Void) {
        let path = dataProvider.objectAtIndexPath(indexPath).images.fixed_width.url
        giphyClient.retrieveImageSequence(path: path)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { imageSequence in
                completion(imageSequence)
            })
            .disposed(by: bag)
    }

    func transform(input: TrendingViewModel.Input) -> TrendingViewModel.Output {

        self.dataProvider = input.dataProvider
        dataProvider.imageSequenceRetriever = imageSequence

        let firstPage = giphyClient.trendingGIFs(pageLimit: numberPerPage)
        let nextPages = Observable.from(1..<numberOfPages)
            .flatMap { _ in
                self.giphyClient.getNextPage()
        }
        Observable.concat(firstPage.take(1), nextPages)
            .subscribe(onNext: { [unowned self] (result: SearchResult) in
                guard let gifs = result.value else {
                    return
                }
                self.dataProvider.appendData(gifs.data)
            })
            .disposed(by: bag)

        input.itemSelected
            .subscribe(onNext: {[unowned self] indexPath in self.itemSelected(indexPath) })
            .disposed(by: bag)
        return Output()
    }

    private func itemSelected(_ indexPath: IndexPath) {

        let object = dataProvider.objectAtIndexPath(indexPath)
        var objectWithImageSequence = object

        guard let retriever = object.imageSequenceRetriever else {
            return
        }
        var count = 0
        retriever(indexPath) { [unowned self] (imageSequence: UIImageSequence) in
            count += 1
            if count == 2 {
                return
            }
            objectWithImageSequence.imageSequence = imageSequence
            self.giphyClient.storeItem(gif: objectWithImageSequence)
            self.interaction.setState(.gifSelected)
        }
    }
}
