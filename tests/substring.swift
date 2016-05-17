import XCTest

@testable import FastString

class SubstringTests: XCTestCase {

    func testSubstring() {
        let s = FastString("Extract (a rather unimportant) substring")
        let substring = s.subString(range: 8..<30)
        XCTAssert(substring == "(a rather unimportant)")
    }

    func testSubstringFullRange() {
        let s = FastString("Extract (a rather unimportant) substring")
        let substring = s.subString(range: 0..<s.byteCount)
        XCTAssert(substring == s)
    }

    func testSubstringToIndex() {
        let s = FastString("Extract (a rather unimportant) substring")
        let substring = s.subString(toIndex: 8)
        XCTAssert(substring == "Extract ")
    }

    func testSubstringFromIndex() {
        let s = FastString("Extract (a rather unimportant) substring")
        let substring = s.subString(fromIndex: 8)
        XCTAssert(substring == "(a rather unimportant) substring")
    }
}

extension SubstringTests {
    static var allTests : [(String, SubstringTests -> () throws -> Void)] {
        return [
            ("testSubstring", testSubstring),
            ("testSubstringFullRange", testSubstringFullRange),
            ("testSubstringToIndex", testSubstringToIndex),
            ("testSubstringFromIndex", testSubstringFromIndex),
        ]
    }
}
