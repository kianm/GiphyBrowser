//
//  KMOperationExecutor.swift
//  KMOperation
//
//  Created by kian on 6/24/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation
import RxSwift

public protocol KMOperationExecutorType {
    func enqueueFunction<X, Y>(_ function: @escaping (X) -> Y, arg: X, subject: ReplaySubject<Y>) -> Int
    func cancelOperation(index: Int)
}

public class KMOperationExecutor: KMOperationExecutorType {

    let opQueue = OperationQueue()
    let maxConcurrentOperationCount = 1
    let serialQueue = DispatchQueue(label: "KMOperationExecutorQueue")
    var operationIndex = -1

    func enqueueOperation(_ operation: Operation) {
        opQueue.addOperation(operation)
    }

    func waitUntilAllOperationsAreFinished() {
        opQueue.waitUntilAllOperationsAreFinished()
    }

    public func enqueueFunction<X, Y>(_ function: @escaping (X) -> Y, arg: X, subject: ReplaySubject<Y>) -> Int {
        autoreleasepool {
            operationIndex += 1
            let operation = KMOperationSubjectable(arg, subject: subject, function: function, index: operationIndex)
            enqueueOperation(operation)
        }
        return operationIndex
    }
    public func cancelOperation(index: Int) {
        for operation in opQueue.operations {
            guard let operationSubjectable = operation as? KMOperationSubjectableType else {
                continue
            }
            if operationSubjectable.index == index {
                operationSubjectable.cancel()
                return
            }
        }
    }
    public init() {
        opQueue.maxConcurrentOperationCount = maxConcurrentOperationCount
        opQueue.underlyingQueue = serialQueue
    }
}
