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
        
        let testInputs:[([String], Version -> () -> Version)] = [
            (["--major"], Version.nextMajorVersion),
            (["--minor"], Version.nextMinorVersion),
            (["--patch"], Version.nextPatchVersion),
            (["--major", "--alpha"], Version.nextMajorAlphaVersion),
            (["--minor", "--alpha"], Version.nextMinorAlphaVersion),
            (["--patch", "--alpha"], Version.nextPatchAlphaVersion),
            (["--major", "--beta"], Version.nextMajorBetaVersion),
            (["--minor", "--beta"], Version.nextMinorBetaVersion),
            (["--patch", "--beta"], Version.nextPatchBetaVersion),
            (["--major", "--alpha"].reverse(), Version.nextMajorAlphaVersion),
            (["--minor", "--alpha"].reverse(), Version.nextMinorAlphaVersion),
            (["--patch", "--alpha"].reverse(), Version.nextPatchAlphaVersion),
            (["--major", "--beta"].reverse(), Version.nextMajorBetaVersion),
            (["--minor", "--beta"].reverse(), Version.nextMinorBetaVersion),
            (["--patch", "--beta"].reverse(), Version.nextPatchBetaVersion)
        ]
        
        
        for input in testInputs {
            let nextVersion = parseNormalizedIncrementingOptions(input.0)!(version)()
            XCTAssertEqual(input.1(version)(), nextVersion, "Invalid incrementor for options \(input.0)")
        }
    }
}

