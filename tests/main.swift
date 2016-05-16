//
//  main.swift
//  DEjson Tests
//
//  Created by Johannes Schriewer on 08/12/15.
//  Copyright © 2015 Johannes Schriewer. All rights reserved.
//

import XCTest

print("Starting tests...")
XCTMain([
    testCase(AppendTests.allTests),
    testCase(ReplaceTests.allTests),
    testCase(SearchTests.allTests),
    testCase(SplitTests.allTests),
    testCase(SubstringTests.allTests)
])