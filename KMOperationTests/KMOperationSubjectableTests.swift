//
//  KMOperationSubjectableTests.swift
//  KMOperationTests
//
//  Created by kian on 6/23/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import XCTest
import RxSwift
import KMOperation

class KMOperationSubjectableTests: XCTestCase {

    func requestAndObserve(_ request: KMOperationRequest, _ arg: Int) -> Bool {
        let bag = DisposeBag()
        let latch = CountDownLatch(count: 1)
        var check = false
        request.doTaskP(arg: arg)
            .subscribe(onNext: { (taskResult: Result) in
                check = String(taskResult.0) == taskResult.1
            }, onError: { (_: Error) in
            }, onCompleted: {
            }, onDisposed: {
                latch.countDown()
            })
            .disposed(by: bag)
        latch.await()
        return check
    }

    func testOnce() {
        let task = KMOperationTask()
        let request = KMOperationRequest(task: task)
        printRxResources()
        for index in 0..<3 {
            printRxResources()
            XCTAssertTrue(requestAndObserve(request, index))
        }
        printRxResources()
    }

    func printRxResources() {
        print("testEmpty Resource count  \(RxSwift.Resources.total)")
    }
}
