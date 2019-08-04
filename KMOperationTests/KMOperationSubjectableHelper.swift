//
//  KMOperationSubjectableHelper.swift
//  KMOperationTests
//
//  Created by kian on 6/28/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation
import RxSwift
@testable import KMOperation

typealias Result = (Int, String)

class KMOperationTask: ExecutorInjected {

    private func f(_ arg: Int) -> Result {
        return (arg, String(arg))
    }

    func perform(arg: Int, subject: ReplaySubject<Result>) {
        operationExecutor.enqueueFunction(f, arg: arg, subject: subject)
    }
}

class KMOperationRequest {

    private var task: KMOperationTask

    func doTaskP(arg: Int) -> ReplaySubject<Result> {
        let subject = ReplaySubject<Result>.create(bufferSize: 2)
        task.perform(arg: arg, subject: subject)
        return subject
    }
    init(task: KMOperationTask) {
        self.task = task
    }
}
