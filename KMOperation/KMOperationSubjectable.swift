//
//  KMOperationSubjectable.swift
//  KMOperation
//
//  Created by kian on 6/23/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation
import RxSwift

protocol KMOperationSubjectableType: Operation {
    func abort()
    var index: Int {get}
}

public class KMOperationSubjectable<I, R>: Operation, KMOperationSubjectableType {

    var index: Int
    private var arg: I
    private var function: (I) -> R
    private var subject: ReplaySubject<R>
    private var shouldProceed: Bool = true
    public init(_ arg: I, subject: ReplaySubject<R>, function: @escaping ((I) -> R), index: Int) {
        self.arg = arg
        self.subject = subject
        self.function = function
        self.index = index
    }
    public override func main() {
        if shouldProceed {
            self.subject.onNext(function(arg))
            self.subject.onCompleted()
        } else {
            self.subject.onCompleted()
        }
    }
    public func abort() {
        shouldProceed = false
    }
}
