/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows an example of implementing the OperationCondition protocol.
*/

import Foundation

/// A generic condition for describing kinds of operations that may not execute concurrently.
public struct MutuallyExclusive<T>: OperationCondition {
    public static var name: String {
        return "MutuallyExclusive<\(T.self)>"
    }

    public static var isMutuallyExclusive: Bool {
        return true
    }
    
    public init() { }
    
    public func dependencyForOperation(_ operation: Operation) -> Foundation.Operation? {
        return nil
    }
    
    public func evaluateForOperation(_ operation: Operation, completion: @escaping (OperationConditionResult) -> Void) {
        completion(.satisfied)
    }
}
