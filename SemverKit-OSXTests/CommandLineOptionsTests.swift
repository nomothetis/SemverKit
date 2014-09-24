//
//  CommandLineOptionsTests.swift
//  SemverKit
//
//  Created by Salazar, Alexandros on 9/24/14.
//  Copyright (c) 2014 nomothetis. All rights reserved.
//

import XCTest
import SemverKit

class CommandLineOptionsTests: XCTestCase {
    
    func testInvalidInput() {
        let invalidOptions:[[String]] = [
            [],
            ["--hi"],
            ["boo"],
            ["--hi", "--alpha"],
            ["--hi", "--beta"],
            ["--hi"]
        ]
        
        for arr in invalidOptions {
            let val = parseNormalizedIncrementingOptions(arr)
            XCTAssert(val == nil, "Options \(arr) should result in a nil incrementing function.")
        }
    }
    
    func testValidInput() {
        let version = parseVersion("2.0.0")+!
        
        var opts = ["--major"]
        let incrementor = parseNormalizedIncrementingOptions(opts)!
        var nextVersion = incrementor(version)()
        XCTAssertEqual(version.nextMajorVersion(), nextVersion, "Invalid incrementor for options \(opts)")
        XCTAssertNotEqual(version.nextMajorAlphaVersion(), nextVersion, "Invalid incrementor")
    }
}

