//
//  CountDownLatchTests.swift
//  KMOperationTests
//
//  Created by kian on 6/23/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import XCTest
import KMOperation

public class CountDownLatchTests: XCTestCase {

    var latch: CountDownLatch!

    override public func setUp() {
        latch = CountDownLatch(count: 1000)
    }

    func testLatchBeingFreed() {
        for _ in 0..<1000 {
            DispatchQueue.global(qos: .background).async {
                self.latch.countDown()
            }
        }
        let freedBeforeTimeout = latch.await(timeout: 1.0E-03)
        XCTAssertTrue(freedBeforeTimeout)
    }

    func testLatchNotBeingFreed() {
        for _ in 0..<999 {
            DispatchQueue.global(qos: .background).async {
                self.latch?.countDown()
            }
        }
        let freedBeforeTimeout = latch.await(timeout: 1.0E-03)
        XCTAssertFalse(freedBeforeTimeout)
    }

}
