//
//  SemverKitTests.swift
//  SemverKitTests
//
//  Created by Salazar, Alexandros on 9/15/14.
//  Copyright (c) 2014 nomothetis. All rights reserved.
//

import XCTest
import Box
import Result
import SemverKit

class CoreTests: XCTestCase {
    
    func testParserErrors() {
        var badVersionStrings = [
            // First: what if there are not enough elements in a simple normal version?
            "", "2", "2.1",
            // Second, what if the characters are not acceptable?
            "*.1", "5.1.^", "5.#.2",
            // Third, what if there are not enough elements in a normal version with pre-release
            // info?
            "5.2-alpha.0", "5-alpha.0",
            // Fourth, what if there are too many elements in a simple normal version?
            "5.0.0.0",
            // Fifth, what if there is a .- sequence?
            "5.0.0.-alpha.0", "5.0.-alpha.0", "5.-alpha.0",
            // Finally, what if there are empty components?
            "5.0..", ".3.1",
            
            
            // Great, normal option parsing seems to fail when expected. Now what about pre-release info?
            // What if there is an incorrect character?
            "2.2.1-alpha.*", "2.2.1-3.*.boom", "12.256.3-3.*.boom.45",
            // What if there are empty components?
            "5.0.0-alpha..0",
            // What if there is no pre-release info, but we go straight to metadata?
            "2.2.1-+hello",
            
            // Great, pre-release info seems to fail when expected. Now for the metadata.
            // What if it contains invalid characters?
            "2.2.1+h*23", "2.2.1-alpha.0+alkj&^",
            // What if it contains empty components?
            "2.3.5+h..3"
        ]
        
        for str in badVersionStrings {
            let result = parseVersion(str)
            result.map { version in
                XCTFail("Parsed \"\(str)\" as \"\(version)\" when it should have caused an error.")
            }
        }
        
    }
    
    func testParserOnValidInput() {
        // Normal version.
        var str = "2.1.0"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 2, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 1, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.None, "Unexpected pre-release for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "2.1.0", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        // Normal version with large numbers.
        str = "2900.1023456.23475323"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 2900, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 1023456, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 23475323, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.None, "Unexpected pre-release for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "2900.1023456.23475323", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        // Pre-release (examples from spec)
        str = "1.0.0-alpha"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.Alpha(-1), "Incorrect pre-release info for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "1.0.0-alpha", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        
        str = "1.0.0-alpha.1"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.Alpha(1), "Incorrect pre-release info for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "1.0.0-alpha.1", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "1.0.0-0.3.7"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.arbitrary(["0", "3", "7"]), "Incorrect pre-release info for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "1.0.0-0.3.7", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "1.0.0-x.7.z.92"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.arbitrary(["x", "7", "z", "92"]), "Incorrect pre-release info for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "1.0.0-x.7.z.92", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        // Some edge-case pre-release info.
        str = "1.0.0-x.7.secret-alpha.92"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.arbitrary(["x", "7", "secret-alpha", "92"]), "Incorrect pre-release info for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "1.0.0-x.7.secret-alpha.92", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "1.0.0-x.7.secret-alpha.92"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.arbitrary(["x", "7", "secret-alpha", "92"]), "Incorrect pre-release info for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "1.0.0-x.7.secret-alpha.92", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "1.0.0-alpha.-1"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.arbitrary(["alpha", "-1"]), "Incorrect pre-release info for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "1.0.0-alpha.-1", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        str = "1.0.0--alpha.1"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.arbitrary(["-alpha", "1"]), "Incorrect pre-release info for version string \"\(str)\".")
            XCTAssertNil(version.metadata, "Unexpected metadata for version string \"\(str)\"")
            XCTAssertEqual(version.description, "1.0.0--alpha.1", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        // Pre-release works, now let's check metadata.
        // First, with no pre-release:
        str = "1.0.0+x.7.ver92"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.None, "Unexpected prerelease for version string \"\(str)\"")
            XCTAssertEqual(version.metadata!, "x.7.ver92", "Incorrect metadata info for version string \"\(str)\".")
            XCTAssertEqual(version.description, "1.0.0+x.7.ver92", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        // Now with pre-release.
        str = "1.0.0-alpha.13+x.7.ver92"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.Alpha(13), "Incorrect prerelease info for version string \"\(str)\"")
            XCTAssertEqual(version.metadata!, "x.7.ver92", "Incorrect metadata info for version string \"\(str)\".")
            XCTAssertEqual(version.description, "1.0.0-alpha.13+x.7.ver92", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
        
        
        // And edge cases.
        str = "1.0.0-alpha.13+-x.7.ver92"
        switch parseVersion(str) {
        case .Success(let box):
            let version = box.value
            XCTAssertEqual(version.major, 1, "Incorrect major version for version string \"\(str)\".")
            XCTAssertEqual(version.minor, 0, "Incorrect minor version for version string \"\(str)\".")
            XCTAssertEqual(version.patch, 0, "Incorrect patch version for version string \"\(str)\".")
            XCTAssertEqual(version.preRelease, Version.PreReleaseInfo.Alpha(13), "Incorrect prerelease info for version string \"\(str)\"")
            XCTAssertEqual(version.metadata!, "-x.7.ver92", "Incorrect metadata info for version string \"\(str)\".")
            XCTAssertEqual(version.description, "1.0.0-alpha.13+-x.7.ver92", "Unexpected description for version.")
        case .Failure(let err):
            XCTFail("Parsing version string \"\(str)\" unexpectedly failed with error: \(err)")
        }
    }
    
    func testVersionMetadataIgnoredInEquality() {
        let ver1 = Version(major:0, minor:0, patch:1, preRelease: nil, metadata:"234df")
        let ver2 = Version(major:0, minor:0, patch:1, preRelease: nil, metadata:"alkjd")
        
        XCTAssertEqual(ver1, ver2, "Metadata should be ignored in version comparisons.")
        
        let ver3 = Version(major:0, minor:0, patch:1, preRelease: nil, metadata:"1.2.3")
        let ver4 = Version(major:0, minor:0, patch:1, preRelease: nil, metadata:"5.3.4")
        
        XCTAssertEqual(ver3, ver4, "Metadata should be ignored in version comparisons.")
        
        let ver5 = Version(major:0, minor:0, patch:1, preRelease: nil)
        let ver6 = Version(major:0, minor:0, patch:1, preRelease: nil, metadata:"5.3.4")
        
        XCTAssertEqual(ver5, ver6, "Metadata should be ignored in version comparisons.")
        
        let ver7 = Version(major:0, minor:0, patch:1, preRelease: nil, metadata:"5.3.4")
        let ver8 = Version(major:0, minor:0, patch:1, preRelease: nil)
        
        XCTAssertEqual(ver5, ver6, "Metadata should be ignored in version comparisons.")
    }
    
    func testVersionComparison() {
        /*
        If the comparison operators work, sorting will also work. So we just need to sort an
        array of versions.
        */
        let versionStrings = [
            "0.1.0-rc.1",
            "0.0.1-alpha.0",
            "0.0.1",
            "0.0.2-alpha.0",
            "0.0.2-alpha.0.1",
            "0.0.2",
            "0.0.3-aaa.11",
            "0.0.3-aaa.2",
            "0.0.3-aaa",
            "0.0.3-alpha.1",
            "0.1.0-beta.2",
            "0.1.0-beta.3",
            "0.1.0",
            "1.0.1",
            "1.0.0-alpha.0",
            "1.0.0",
            "0.0.2-alpha",
            "1.1.0",
            "0.1.0-alpha.3",
            "1.2.0",
            "2.0.0-alpha.0",
            "2.0.0-1",
            "1.0.0-1",
            "1.0.0-3",
            "1.0.0-11",
        ]
        
        let versions = versionStrings.map(parseVersion).map(forceUnwrap)
        let sortedVersions = sorted(versions)
        
        let preSortedVersions = [
            "0.0.1-alpha.0",
            "0.0.1",
            "0.0.2-alpha",
            "0.0.2-alpha.0",
            "0.0.2-alpha.0.1",
            "0.0.2",
            "0.0.3-aaa",
            "0.0.3-aaa.2",
            "0.0.3-aaa.11",
            "0.0.3-alpha.1",
            "0.1.0-alpha.3",
            "0.1.0-beta.2",
            "0.1.0-beta.3",
            "0.1.0-rc.1",
            "0.1.0",
            "1.0.0-1",
            "1.0.0-3",
            "1.0.0-11",
            "1.0.0-alpha.0",
            "1.0.0",
            "1.0.1",
            "1.1.0",
            "1.2.0",
            "2.0.0-1",
            "2.0.0-alpha.0"
            ].map(parseVersion).map(forceUnwrap)
        
        XCTAssertEqual(sortedVersions, preSortedVersions, "Versions not sorted properly!")
    }
    
    func testVersionNonEquality() {
        let pairs:[[String]] = [
            ["3.0.0", "3.0.0-alpha.0"],
            ["3.0.0", "3.0.1"],
            ["3.0.0", "3.1.0"],
            ["4.0.0", "3.0.0"],
            ["3.0.0-alpha.0", "3.0.0-alpha.5"],
            ["3.0.0-alpha.0", "3.0.0-beta.0"],
            ["3.0.0-alpha.0", "3.0.0-boo"],
            ["3.0.0", "3.1.1"],
            ["3.0.0-alpha.0", "3.0.1-alpha.1"]
        ]
        
        for pair in pairs {
            let version1 = parseVersion(pair[0])+!
            let version2 = parseVersion(pair[1])+!
            XCTAssertNotEqual(version1, version2, "Invalid equality")
        }
    }
    
    func testVersionEquality() {
        let pairs:[[String]] = [
            ["3.0.0", "3.0.0"],
            ["3.0.1", "3.0.1"],
            ["3.1.0", "3.1.0"],
            ["3.0.0-alpha.0", "3.0.0-alpha.0"],
            ["3.0.0-beta.0", "3.0.0-beta.0"],
            ["3.0.0-boo", "3.0.0-boo"],
            ["3.0.0", "3.0.0+metadata"],
            ["3.0.1", "3.0.1+metadata"],
            ["3.1.0", "3.1.0+metadata"],
            ["3.0.0-alpha.0", "3.0.0-alpha.0+metadata"],
            ["3.0.0-beta.0", "3.0.0-beta.0+metadata"],
            ["3.0.0-boo", "3.0.0-boo+metadata"],
        ]
        
        for pair in pairs {
            let version1 = parseVersion(pair[0])+!
            let version2 = parseVersion(pair[1])+!
            XCTAssertEqual(version1, version2, "Invalid equality")
        }
    }
    
}

/* Of course we would never do this in production code, but this is test code, so it's alright. */
func forceUnwrap<T, E>(result:Result<T, E>) -> T {
    switch result {
    case .Success(let box):
        return box.value
    case .Failure(let err):
        println("Failed to unwrap \(result)")
        abort()
    }
}

postfix operator +! {}
postfix func +!<T, E>(val:Result<T, E>) -> T {
    return forceUnwrap(val)
}
