//
//  IncrementTests.swift
//  SemverKit
//
//  Created by Salazar, Alexandros on 9/15/14.
//  Copyright (c) 2014 nomothetis. All rights reserved.
//

import Foundation
import XCTest
import SemverKit
import Box

class IncrementTests : XCTestCase {
    func testNextMajorVersion() {
        let strs = [ // begin by testing regular values
            "3.2.5", "3.0.0", "0.0.37", "0.0.0",
            // Now look at values with prerelease info
            "3.4.5-alpha.3", "2.0.0-beta.7", "3.4.7-wat.whee",
            // Finally, let's look at value with metadata
            "3.4.5-alpha.3+metadata", "3.0.0+mystery"
        ]
        
        for str in strs {
            switch parseVersion(str) {
            case .Success(let box):
                let version = box.value
                let nextVersion = box.value.nextMajorVersion()
                let finalErrStr = "for next major version of \"\(str)\"."
                XCTAssertEqual(nextVersion.major, version.major + 1, "Incorrect major version \(finalErrStr)")
                XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
                XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
                XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.None, "Incorrect prerelease info \(finalErrStr)")
                XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
            case .Failure(let err):
                XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
            }
        }
    }
    
    func testNextMinorVersion() {
        let strs = [ // begin by testing regular values
            "3.2.5", "3.0.0", "0.0.37", "0.0.0",
            // Now look at values with prerelease info
            "3.4.5-alpha.3", "2.0.0-beta.7", "3.4.7-wat.whee",
            // Finally, let's look at value with metadata
            "3.4.5-alpha.3+metadata", "3.0.0+mystery"
        ]
        
        for str in strs {
            switch parseVersion(str) {
            case .Success(let box):
                let version = box.value
                let nextVersion = box.value.nextMinorVersion()
                let finalErrStr = "for next minor version of \"\(str)\"."
                XCTAssertEqual(nextVersion.major, version.major, "Incorrect major version \(finalErrStr)")
                XCTAssertEqual(nextVersion.minor, version.minor + 1, "Incorrect minor version \(finalErrStr)")
                XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
                XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.None, "Incorrect prerelease info \(finalErrStr)")
                XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
            case .Failure(let err):
                XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
            }
        }
    }
    
    func testNextPatchVersion() {
        let strs = [ // begin by testing regular values
            "3.2.5", "3.0.0", "0.0.37", "0.0.0",
            // Now look at values with prerelease info
            "3.4.5-alpha.3", "2.0.0-beta.7", "3.4.7-wat.whee",
            // Finally, let's look at value with metadata
            "3.4.5-alpha.3+metadata", "3.0.0+mystery"
        ]
        
        for str in strs {
            switch parseVersion(str) {
            case .Success(let box):
                let version = box.value
                let nextVersion = box.value.nextPatchVersion()
                let finalErrStr = "for next patch version of \"\(str)\"."
                XCTAssertEqual(nextVersion.major, version.major, "Incorrect major version \(finalErrStr)")
                XCTAssertEqual(nextVersion.minor, version.minor, "Incorrect minor version \(finalErrStr)")
                XCTAssertEqual(nextVersion.patch, version.patch + 1, "Incorrect patch version \(finalErrStr)")
                XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.None, "Incorrect prerelease info \(finalErrStr)")
                XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
            case .Failure(let err):
                XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
            }
        }
    }
    
    func testNextMajorAlphaVersion() {
        var str = "2.0.2"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 3, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.2.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 3, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.0-alpha.4"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 3, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.8-alpha.4"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 3, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.0-alpha.4"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(5), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.0-alpha"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.0-45423"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.0-tom"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 3, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
    }
    
    func testNextMinorAlphaVersion() {
        var str = "2.0.2"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.2-alpha.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.2-alpha.5"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.0-alpha.5"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(6), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.0-beta.5"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 2, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.0-12"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.0-alpha.k"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorAlphaVersion()
            let finalErrStr = "for next minor alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
    }
    
    func testNextPatchAlphaVersion() {
        var str = "5.0.3"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchAlphaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 4, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.0.3-alpha.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchAlphaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 3, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(1), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.0.3-beta.7"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchAlphaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 4, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.0.3-alpha"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchAlphaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 3, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.0.3-alpha.m"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchAlphaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 4, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Alpha(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
    }
    
    func testNextMajorBetaVersion() {
        var str = "5.0.3"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 6, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.2.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 6, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.2.0-alpha.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 6, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.2.0-beta.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 6, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.0.0-beta.2"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(3), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.0.0-beta.2+metadata"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(3), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.0.0-tim"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 6, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.0.0-123"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMajorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
    }
    
    func testNextMinorBetaRelease() {
        var str = "5.1.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 2, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "5.1.0-alpha.2"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 5, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.0-beta.2"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(3), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.2-beta.2"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 2, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.0-done"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 2, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.0-23"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.0-beta"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextMinorBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
    }
    
    func testNextPatchBetaVersion() {
        var str = "2.1.0-beta"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 1, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.1.0-beta.1"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(2), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 1, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "2.0.0-700"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextPatchBetaVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.Beta(0), "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
    }
    
    func testNextStableVersion() {
        // If we're already stable, we shoudl still be stable.
        var str = "2.0.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextStableVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.None, "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "3.1.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextStableVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 3, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.None, "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "19.7.2"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextStableVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 19, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 7, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 2, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.None, "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        // Pre-release versions are properly dropped.
        
        str = "2.0.0-alpha.1"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextStableVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 2, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 0, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.None, "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "3.1.0-beta.23"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextStableVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 3, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 1, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 0, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.None, "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "19.7.2-test"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            let nextVersion = box.value.nextStableVersion()
            let finalErrStr = "for next patch alpha version of \"\(str)\"."
            XCTAssertEqual(nextVersion.major, 19, "Incorrect major version \(finalErrStr)")
            XCTAssertEqual(nextVersion.minor, 7, "Incorrect minor version \(finalErrStr)")
            XCTAssertEqual(nextVersion.patch, 2, "Incorrect patch version \(finalErrStr)")
            XCTAssertEqual(nextVersion.preRelease, Version.PreReleaseInfo.None, "Incorrect prerelease info \(finalErrStr)")
            XCTAssert(nextVersion.metadata == nil, "Unexpected metadata info \(finalErrStr)")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
    }
}