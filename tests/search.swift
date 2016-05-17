import XCTest

@testable import FastString

class SearchTests: XCTestCase {
    // MARK: Position of char

    func testPositionOfChar() {
        let c: Character = "."
        let s = FastString("Just a string with a . in it")
        if let result = s.position(character: c) {
            XCTAssert(result == 21)
        } else {
            XCTFail(". not found")
        }
    }

    func testPositionOfCharNotFound() {
        let c: Character = "!"
        let s = FastString("Just a string with a . in it")
        if let _ = s.position(character: c) {
            XCTFail("Should not find a position")
        }
    }

    func testPositionOfCharReverse() {
        let c: Character = "i"
        let s = FastString("Just a string with a . in it")
        if let result = s.position(character: c, reverse: true) {
            XCTAssert(result == 26)
        } else {
            XCTFail("i not found")
        }
    }

    func testPositionOfCharStartIndex() {
        let c: Character = "i"
        let s = FastString("Just a string with a . in it")
        if let result = s.position(character: c, index: 22) {
            XCTAssert(result == 23)
        } else {
            XCTFail("i not found")
        }
    }

    func testPositionOfCharStartIndexReverse() {
        let c: Character = "i"
        let s = FastString("Just a string with a . in it")
        if let result = s.position(character: c, index: 25, reverse: true) {
            XCTAssert(result == 23)
        } else {
            XCTFail("i not found")
        }
    }

    func testPositionsOfChar() {
        let c: Character = "i"
        let s = FastString("Just a string with a . in it")
        let result = s.positions(character: c)
        XCTAssert(result.count == 4)
        if result.count == 4 {
            XCTAssert(result[0] == 10)
            XCTAssert(result[1] == 15)
            XCTAssert(result[2] == 23)
            XCTAssert(result[3] == 26)
        }
    }

    func testPositionsOfCharNotFound() {
        let c: Character = "!"
        let s = FastString("Just a string with a . in it")
        let result = s.positions(character: c)
        XCTAssert(result.count == 0)
    }

    // MARK: Position of string

    func testPositionOfString() {
        let n = "a "
        let s = FastString("Just a string with a . in it")
        if let result = s.position(string: n) {
            XCTAssert(result == 5)
        } else {
            XCTFail("'a ' not found")
        }
    }

    func testPositionOfStringNotFound() {
        let n = "! "
        let s = FastString("Just a string with a . in it")
        if let _ = s.position(string: n) {
            XCTFail("Should not find a position")
        }
    }

    func testPositionOfStringReverse() {
        let n = "a "
        let s = FastString("Just a string with a . in it")
        if let result = s.position(string: n, reverse: true) {
            XCTAssert(result == 19)
        } else {
            XCTFail("'a ' not found")
        }
    }

    func testPositionOfStringStartIndex() {
        let n = "a "
        let s = FastString("Just a string with a . in it")
        if let result = s.position(string: n, index: 10) {
            XCTAssert(result == 19)
        } else {
            XCTFail("'a ' not found")
        }
    }

    func testPositionOfStringStartIndexReverse() {
        let n = "a "
        let s = FastString("Just a string with a . in it")
        if let result = s.position(string: n, index: 10, reverse: true) {
            XCTAssert(result == 5)
        } else {
            XCTFail("'a ' not found")
        }
    }

    func testPositionsOfString() {
        let n = "a "
        let s = FastString("Just a string with a . in it")
        let result = s.positions(string: n)
        XCTAssert(result.count == 2)
        if result.count == 2 {
            XCTAssert(result[0] == 5)
            XCTAssert(result[1] == 19)
        }
    }

    func testPositionsOfStringNotFound() {
        let n = "! "
        let s = FastString("Just a string with a . in it")
        let result = s.positions(string: n)
        XCTAssert(result.count == 0)
    }

    // MARK: Contains

    func testContainsChar() {
        let c: Character = "."
        let s = FastString("Just a string with a . in it")
        XCTAssertTrue(s.contains(character: c))
    }

    func testContainsCharNotFound() {
        let c: Character = "!"
        let s = FastString("Just a string with a . in it")
        XCTAssertFalse(s.contains(character: c))
    }

    func testContainsString() {
        let n = "in"
        let s = FastString("Just a string with a . in it")
        XCTAssertTrue(s.contains(string: n))
    }

    func testContainsStringNotFound() {
        let n = "out"
        let s = FastString("Just a string with a . in it")
        XCTAssertFalse(s.contains(string: n))
    }


    // MARK: Prefix

    func testHasPrefix() {
        let s = FastString("Just a string with a . in it")
        XCTAssertTrue(s.hasPrefix("Just"))
    }

    func testHasPrefixNotFound() {
        let s = FastString("Just a string with a . in it")
        XCTAssertFalse(s.hasPrefix("Foobar"))
    }

    func testHasEmptyPrefix() {
        let s = FastString("Just a string with a . in it")
        XCTAssertTrue(s.hasPrefix(""))
    }

    func testHasTooLongPrefix() {
        let s = FastString("Just")
        XCTAssertFalse(s.hasPrefix("Just a long prefix"))
    }

    func testHasPrefixAlike() {
        let s = FastString("Just a string with a . in it")
        XCTAssertFalse(s.hasPrefix("Just a  thing"))
    }

    // MARK: Suffix

    func testHasSuffix() {
        let s = FastString("Just a string with a . in it")
        XCTAssertTrue(s.hasSuffix("in it"))
    }

    func testHasSuffixNotFound() {
        let s = FastString("Just a string with a . in it")
        XCTAssertFalse(s.hasSuffix("foobar"))
    }

    func testHasEmptySuffix() {
        let s = FastString("Just a string with a . in it")
        XCTAssertTrue(s.hasSuffix(""))
    }

    func testHasTooLongSuffix() {
        let s = FastString("Just")
        XCTAssertFalse(s.hasSuffix("Just a long prefix"))
    }

    func testHasSuffixAlike() {
        let s = FastString("Just a string with a . in it")
        XCTAssertFalse(s.hasSuffix(". of it"))
    }
}

extension SearchTests {
    static var allTests : [(String, SearchTests -> () throws -> Void)] {
        return [
            ("testPositionOfChar", testPositionOfChar),
            ("testPositionOfCharNotFound", testPositionOfCharNotFound),
            ("testPositionOfCharReverse", testPositionOfCharReverse),
            ("testPositionOfCharStartIndex", testPositionOfCharStartIndex),
            ("testPositionOfCharStartIndexReverse", testPositionOfCharStartIndexReverse),
            ("testPositionsOfChar", testPositionsOfChar),
            ("testPositionsOfCharNotFound", testPositionsOfCharNotFound),
            ("testPositionOfString", testPositionOfString),
            ("testPositionOfStringNotFound", testPositionOfStringNotFound),
            ("testPositionOfStringReverse", testPositionOfStringReverse),
            ("testPositionOfStringStartIndex", testPositionOfStringStartIndex),
            ("testPositionOfStringStartIndexReverse", testPositionOfStringStartIndexReverse),
            ("testPositionsOfString", testPositionsOfString),
            ("testPositionsOfStringNotFound", testPositionsOfStringNotFound),
            ("testContainsChar", testContainsChar),
            ("testContainsCharNotFound", testContainsCharNotFound),
            ("testContainsString", testContainsString),
            ("testContainsStringNotFound", testContainsStringNotFound),
            ("testHasPrefix", testHasPrefix),
            ("testHasPrefixNotFound", testHasPrefixNotFound),
            ("testHasEmptyPrefix", testHasEmptyPrefix),
            ("testHasTooLongPrefix", testHasTooLongPrefix),
            ("testHasPrefixAlike", testHasPrefixAlike),
            ("testHasSuffix", testHasSuffix),
            ("testHasSuffixNotFound", testHasSuffixNotFound),
            ("testHasEmptySuffix", testHasEmptySuffix),
            ("testHasTooLongSuffix", testHasTooLongSuffix),
            ("testHasSuffixAlike", testHasSuffixAlike)
        ]
    }
}
