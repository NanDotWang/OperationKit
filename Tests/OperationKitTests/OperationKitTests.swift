//
//  OperationKitTests.swift
//  NanTech
//
//  Created by Nan Wang on {TODAY}.
//  Copyright © 2017 NanTech. All rights reserved.
//

import Foundation
import XCTest
import OperationKit

class OperationKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //// XCTAssertEqual(OperationKit().text, "Hello, World!")
    }
}

#if os(Linux)
extension OperationKitTests {
    static var allTests : [(String, (OperationKitTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
#endif
