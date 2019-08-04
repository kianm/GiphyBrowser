//
//  GiphyClientTests.swift
//  GiphyClientTests
//
//  Created by kian on 6/6/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxBlocking
@testable import GiphyClient

class GiphyClientSpecs: QuickSpec {
    
    override func spec() {
        describe("GiphyClient first and next search") {
            let giphyClient = GiphyClient()
            let apiClient = APIClientMock()
            
            beforeEach {
                InjectionMaps.apiClient = apiClient
            }
            
            context("Correct Pagination logic on first search") {
                
                it("should reflect total count") {
                    apiClient.pagination = Pagination(totalCount: 456, count: 20, offset: 0)
                    let _ = try! giphyClient.searchGIF(keyword: "", pageLimit: 20).toBlocking().first()
                    XCTAssertEqual(giphyClient.totalCount, 456)
                }
                
                it("should reflect actual count") {
                    apiClient.pagination = Pagination(totalCount: 456, count: 20, offset: 0)
                    let _ = try! giphyClient.searchGIF(keyword: "", pageLimit: 20).toBlocking().first()
                    XCTAssertEqual(giphyClient.currentCount, 20)
                }
                
                it("should show no change in offset") {
                    apiClient.pagination = Pagination(totalCount: 456, count: 20, offset: 0)
                    let _ = try! giphyClient.searchGIF(keyword: "", pageLimit: 20).toBlocking().first()
                    XCTAssertEqual(giphyClient.offset, 0)
                }
            }
            
            context("Correct Pagination logic on next page request") {
                
                it("should reflect actual count") {
                    apiClient.pagination = Pagination(totalCount: 456, count: 20, offset: 0)
                    let _ = try! giphyClient.searchGIF(keyword: "", pageLimit: 20).toBlocking().first()
                    let _ = try! giphyClient.getNext().toBlocking().first()
                    XCTAssertEqual(giphyClient.currentCount, 40)
                }
                
                it("should show no change in offset") {
                    apiClient.pagination = Pagination(totalCount: 456, count: 20, offset: 0)
                    let _ = try! giphyClient.searchGIF(keyword: "", pageLimit: 20).toBlocking().first()
                    XCTAssertEqual(giphyClient.offset, 0)
                }
            }
        }
    }
}

