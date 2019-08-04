//
//  Injectables.swift
//  KMOperation
//
//  Created by kian on 6/30/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation

struct InjectionMaps {
    static let operationExecutor: KMOperationExecutorType = KMOperationExecutor()
}

protocol ExecutorInjected {}
extension ExecutorInjected {
    var operationExecutor: KMOperationExecutorType { return InjectionMaps.operationExecutor}
}
