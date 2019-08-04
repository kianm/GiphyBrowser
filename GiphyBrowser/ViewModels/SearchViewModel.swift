//
//  SearchViewModel.swift
//  GiphyBrowser
//
//  Created by kian on 8/3/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import GiphyClient
import RxSwift

final class SearchViewModel: ViewModelType, InteractionInjected, GiphyClientInjected {
    private let bag = DisposeBag()
    private var dataProvider: SearchResultDataProvider!
    private var searchResultSubject = PublishSubject<SearchResult>()
    // swiftlint:disable weak_delegate
    struct Input {
        let dataProvider: SearchResultDataProvider
        let searchRequested: Observable<String>
        let reachedEndOfTheList: Observable<Void>
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

    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output {

        self.dataProvider = input.dataProvider
        dataProvider.imageSequenceRetriever = imageSequence

        searchResultSubject
            .filter { $0.wasSuccess}
            .subscribe(onNext: { [unowned self] (result: SearchResult) in
                guard let gifs = result.value else {
                    return
                }
                self.dataProvider.appendData(gifs.data) })
            .disposed(by: bag)

        input.searchRequested
            .do(onNext: {[unowned self] _ in self.dataProvider.clearData() })
            .filter { $0.count > 0 }
            .flatMap { (text: String) -> Observable<SearchResult> in
                return self.giphyClient.searchGIF(keyword: text, pageLimit: 20)
            }
            .subscribe { (event: Event<SearchResult>) in
                self.searchResultSubject.on(event)}
            .disposed(by: bag)
        input.reachedEndOfTheList
            .subscribe(onNext: {[unowned self] _ in self.getNextPage() })
            .disposed(by: bag)
        input.itemSelected
            .subscribe(onNext: {[unowned self] indexPath in self.itemSelected(indexPath) })
            .disposed(by: bag)
        return Output()
    }
    private func getNextPage() {
        giphyClient.getNextPage().observeOn(MainScheduler.asyncInstance)
            .subscribe { (event: Event<SearchResult>) in
                if  event.element != nil {
                    self.searchResultSubject.on(event)
                }
            }
            .disposed(by: bag)
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
