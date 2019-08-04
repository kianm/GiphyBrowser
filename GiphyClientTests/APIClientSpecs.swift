//
//  APIClientSpecs.swift
//  GiphyClientTests
//
//  Created by kian on 6/7/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import GiphyClient

class APIClientSpecs: QuickSpec {
    
    override func spec() {
        describe("APIClient Forming proper URL for search") {
                let networking = NetworkingMock()
            
            beforeEach {
                InjectionMaps.networking = networking
            }
            
            context("when keyword, limit, offset, and rating are given") {
                it("should call Networking client with expected URL") {
                    
                    let _: Observable<SearchResult> = APIClient().searchGifs(keyword: "clown", limit: 26, offset: 4, rating: "Y")
                    let path_api = try! networking.calledWithURL!.asURL().absoluteURL.absoluteString
                    expect(path_api).to(equal("https://api.giphy.com/v1/gifs/search?api_key=bXVopH2VMu5cIJjHCHxLGQ2yNEC8HXp0&q=clown&limit=26&offset=4&rating=Y&lang=en"))
                }
            }
        }
    }
}
