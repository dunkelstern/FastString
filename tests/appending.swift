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