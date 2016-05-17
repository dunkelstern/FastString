// Copyright (c) 2016 Johannes Schriewer.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest

@testable import FastString

class AppendTests: XCTestCase {
    func testAppendingFastStringToFastString() {
        XCTAssert(FastString("Foo") + FastString("Bar") == FastString("FooBar"))
    }

    func testAppendingStringToFastString() {
        XCTAssert(FastString("Foo") + "Bar" == FastString("FooBar"))
    }

    func testAppendingFastStringToString() {
        XCTAssert("Foo" + FastString("Bar") == "FooBar")
    }

    func testAppendFastStringToFastString() {
        let s = FastString("Foo")
        s.append(FastString("Bar"))
        XCTAssert(s == "FooBar")
    }

    func testAppendStringToFastString() {
        let s = FastString("Foo")
        s.append("Bar")
        XCTAssert(s == "FooBar")
    }

    func testAppendFastStringToString() {
        var s = "Foo"
        s += FastString("Bar")
        XCTAssert(s == "FooBar")
    }
}

extension AppendTests {
     static var allTests : [(String, AppendTests -> () throws -> Void)] {
        return [
             ("testAppendingFastStringToFastString", testAppendingFastStringToFastString),
             ("testAppendingStringToFastString", testAppendingStringToFastString),
             ("testAppendingFastStringToString", testAppendingFastStringToString),
             ("testAppendFastStringToFastString", testAppendFastStringToFastString),
             ("testAppendStringToFastString", testAppendStringToFastString),
             ("testAppendFastStringToString", testAppendFastStringToString)
        ]
    }
}