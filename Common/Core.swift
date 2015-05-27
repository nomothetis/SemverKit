//
//  Core.swift
//  SemverKit
//
//  Created by Salazar, Alexandros on 9/15/14.
//  Copyright (c) 2014 nomothetis. All rights reserved.
//

import Foundation
import LlamaKit

/*
Implements the the Semantic Versioning 2.0.0 spec:

http://semver.org/spec/v2.0.0.html

Includes:

    - A Version type
    - Equality and comparison functions
    - Parsing functions
*/

/**
Version type.

A version consists of:

* A major revision
* A minor revision
* A patch revision
* Potentially, pre-release info
* Potentially, metadata

For a full spec, see http://www.semver.org

This type offers facilities for bumping versions in a semantically consistent way. While there are
no requirements on preRelease versions, this class offers facilities for releasing alpha and beta
versions as prerelease info. See the individual methods for semantics.

This type is immutable; therefore no methods are destructive to the data once initialized.
*/
public struct Version : Printable, Comparable {
    public enum PreReleaseIdentifier: Printable, Comparable {
        case Number(Int)
        case String(Swift.String)

        public init(string: Swift.String) {
            if let number = intFromString(string) {
                self = .Number(number)
            } else {
                self = .String(string)
            }
        }

        public var description:Swift.String {
            switch self {
            case .String(let string):
                return string
            case .Number(let number):
                return "\(number)"
            }
        }
    }

    public enum PreReleaseInfo : Printable, Comparable, DebugPrintable {
        case Alpha(Int)
        case Beta(Int)
        case Arbitrary([String])
        case None
        
        static func fromArray(arr:[String]) -> PreReleaseInfo {
            if (arr.count == 0) {
                return .None
            }
            
            if (arr.count == 1) {
                switch arr[0] {
                case "alpha":
                    return .Alpha(-1)
                case "beta":
                    return .Beta(-1)
                default:
                    return .Arbitrary(arr)
                }
            }
            
            if (arr.count == 2) {
                let tuple = (arr[0], intFromString(arr[1]))
                switch tuple {
                case ("alpha", let x) where x != nil:
                    return .Alpha(x!)
                case ("beta", let x) where x != nil:
                    return .Beta(x!)
                default:
                    break
                }
            }
            
            return PreReleaseInfo.Arbitrary(arr)
        }
        
        public var description:String {
            get {
                switch self {
                case .Alpha(let rev):
                    if rev != -1 {
                        return "alpha.\(rev)"
                    } else {
                        return "alpha"
                    }
                case .Beta(let rev):
                    return "beta.\(rev)"
                case .Arbitrary(let info):
                    let joiner = "."
                    return "\((info as NSArray).componentsJoinedByString(joiner))"
                case .None:
                    return ""
                }
            }
        }
        
        public var debugDescription:String {
            get {
                switch self {
                case .Alpha(let rev):
                    if rev != -1 {
                        return "{ Alpha \(rev) }"
                    } else {
                        return "{ Alpha _ }"
                    }
                case .Beta(let rev):
                    return "{ Beta \(rev) }"
                case .Arbitrary(let info):
                    let joiner = "."
                    return "{ Arbitrary \((info as NSArray).componentsJoinedByString(joiner)) }"
                case .None:
                    return "{ None }"
                }
            }
        }
        
        public func toArray() -> [String] {
            switch self {
            case .Alpha(let int):
                if (int >= 0) {
                    return ["alpha", String(int)]
                } else {
                    return ["alpha"]
                }
            case .Beta(let int):
                if (int >= 0) {
                    return ["beta", String(int)]
                } else {
                    return ["beta"]
                }
            case .Arbitrary(let arr):
                return arr
            case .None:
                return []
            }
        }
    }
    
    public let major:Int
    public let minor:Int
    public let patch:Int
    public let preRelease:PreReleaseInfo
    public let metadata:String?
    
    public init(major maj:Int, minor min:Int, patch ptch:Int, preRelease prl:[String]? = nil, metadata mtd:String? = nil) {
        self.major = maj
        self.minor = min
        self.patch = ptch
        if let prl = prl {
            self.preRelease = PreReleaseInfo.fromArray(prl)
        } else {
            self.preRelease = PreReleaseInfo.None
        }
        self.metadata = mtd
    }
    
    public init(major maj:Int, minor min:Int, patch ptch:Int, preRelease prl:PreReleaseInfo = .None, metadata mtd:String? = nil) {
        self.major = maj
        self.minor = min
        self.patch = ptch
        self.preRelease = prl
        self.metadata = mtd
    }
    
    /**
    Returns a description string that matches the M.m.p-PRERELEASE+METADATA format of the spec.
    
    :return: the description string.
    */
    public var description:String {
        get {
            var desc = "\(self.major).\(self.minor).\(self.patch)"
            
            switch self.preRelease {
            case .None:
                break
            default:
                desc = desc.stringByAppendingString("-\(self.preRelease)")
            }
            
            if let meta = self.metadata {
                desc = desc.stringByAppendingString("+\(meta)")
            }
            
            return desc
        }
    }
    
}

// MARK: Comparable; Equatable

/**
 Implements version equality per the spec.
 */
public func ==(lhs:Version, rhs:Version) -> Bool {
    if lhs.major == rhs.major
        && lhs.minor == rhs.minor
        && lhs.patch == rhs.patch
        && lhs.preRelease == rhs.preRelease { // per the spec, metadata is ignored.
            return true
    }
    
    return false
}

/**
 Implements version comparison per the spec.
 */
public func <(lhs:Version, rhs:Version) -> Bool {
    if lhs.major < rhs.major {
        return true
    }
    
    if (lhs.major > rhs.major) {
        return false
    }
    
    if (lhs.minor < rhs.minor) {
        return true
    }
    
    if (lhs.minor > rhs.minor) {
        return false
    }
    
    if (lhs.patch < rhs.patch) {
        return true
    }
    
    if (lhs.patch > rhs.patch) {
        return false
    }
    
    if (lhs.preRelease < rhs.preRelease) {
        return true
    }
    
    return false
}


/**
 Implements pre-release equality per the spec.
 */
public func ==(lhs:Version.PreReleaseInfo, rhs:Version.PreReleaseInfo) -> Bool {
    let lhsArr = lhs.toArray()
    let rhsArr = rhs.toArray()
    
    if lhsArr.count != rhsArr.count {
        return false
    }
    
    for i in 0..<lhsArr.count {
        if lhsArr[i] != rhsArr[i] {
            return false
        }
    }
    
    return true
}

/**
 Implements pre-release comparison per the spec.
 */
public func <(lhs:Version.PreReleaseInfo, rhs:Version.PreReleaseInfo) -> Bool {
    /* This probably should be done with a zipper, but I don't know how to do that yet in swift. */
    let lhsArr = lhs.toArray()
    let rhsArr = rhs.toArray()
    
    if lhsArr.count == 0 && rhsArr.count == 0 {
        /* Two no-pre-release sides are equal. */
        return false
    }
    
    /* Pre-release has lower priorty than no prerelease. */
    if (lhsArr.count == 0) {
        return false
    }
    
    if (rhsArr.count == 0) {
        return true
    }
    
    var differingIndex = -1
    for i in 0..<min(lhsArr.count, rhsArr.count) {
        if lhsArr[i] == rhsArr[i] {
            continue
        }
        
        differingIndex = i
        break
    }
    
    if (differingIndex == -1) {
        /* the common elements are identical; the longest one has higher priority. */
        return lhsArr.count < rhsArr.count
    }
    
    /* We have differing elements. Assume for now < is lexical. */
    return lhsArr[differingIndex] < rhsArr[differingIndex]
}

/**
Implements pre-release indentifier equality per the spec.
*/
public func ==(lhs:Version.PreReleaseIdentifier, rhs:Version.PreReleaseIdentifier) -> Bool {
    switch (lhs, rhs) {
    case let (.Number(left), .Number(right)):
        return left == right
    case let (.String(left), .String(right)):
        return left == right
    default:
        return false
    }
}

/**
Implements pre-release identifier comparison per the spec.
*/
public func <(lhs:Version.PreReleaseIdentifier, rhs:Version.PreReleaseIdentifier) -> Bool {
    switch (lhs, rhs) {
    /* Per the spec, numeric identifiers sort before strings. */
    case (.Number, .String):
        return true
    case (.String, .Number):
        return false

    /* Otherwise we use normal sorting rules. */
    case let (.Number(left), .Number(right)):
        return left < right
    case let (.String(left), .String(right)):
        return left < right
    }
}


// MARK: Parser

public func parseVersion(versionStrng:String) -> Result<Version, String> {
    if versionStrng.isEmpty {
        return failure("Empty string is not a valid version.")
    }
    
    let scanner = NSScanner(string: versionStrng)
    var normalVersionStringOptional:NSString? = nil
    let success = scanner.scanUpToCharactersFromSet(NSCharacterSet(charactersInString: "-+"), intoString:&normalVersionStringOptional)
    
    if (!success) {
        return failure("Unable to get main version from passed version string: \(versionStrng)")
    }
    
    /* We now know that mainResultString exists. */
    return parseNormalVersionString(normalVersionStringOptional! as String).flatMap{ normalVersionComponents in
        
        if scanner.atEnd {
            let version = Version(major: normalVersionComponents[0], minor: normalVersionComponents[1], patch: normalVersionComponents[2], preRelease: nil)
            return .Success(Box(version))
        }
        
        /*
        We're not at the end, ergo we still have either pre-release info, metadata, or both.
        
        Per the spec, pre-release MUST follow patch, so check for metadata first (if we're at
        the metadata, we're done by defintion).
        */
        let location = scanner.scanLocation
        let nextCharacter = versionStrng[advance(versionStrng.startIndex,location)]
        if nextCharacter == "+" {
            /* We are not quite at end end. Whatever remains is by definition metadata. */
            let metaData = versionStrng[advance(versionStrng.startIndex,scanner.scanLocation + 1)..<versionStrng.endIndex]
            return parseMetadata(metaData).flatMap { mdata in
                return .Success(Box(Version(major: normalVersionComponents[0], minor: normalVersionComponents[1], patch: normalVersionComponents[2], preRelease:nil, metadata: mdata)))
            }
        }
        
        /*
        Okay, we have pre-release info. We must parse until the + sign, since - symbols are legal in
        pre-release info.
        
        Skip the special character.
        */
        scanner.scanLocation = scanner.scanLocation + 1
        
        var preReleaseInfo:NSString? = nil
        let success = scanner.scanUpToCharactersFromSet(NSCharacterSet(charactersInString:"+"), intoString: &preReleaseInfo)
        if (!success) {
            return failure("Unable to get pre-release info for passed string: \(versionStrng)")
        }
        
        /* We have a pre-release string. Parse it. */
        return parsePreReleaseInfo(preReleaseInfo! as String).flatMap { parsedInfo in
            if scanner.atEnd {
                return Result.Success(Box(Version(major: normalVersionComponents[0], minor: normalVersionComponents[1], patch: normalVersionComponents[2], preRelease:parsedInfo)))
            }
            
            /* We are not quite at end end. Whatever remains is by definition metadata. */
            let metaData = versionStrng[advance(versionStrng.startIndex,scanner.scanLocation + 1)..<versionStrng.endIndex]
            return parseMetadata(metaData).flatMap { mdata in
                return .Success(Box(Version(major: normalVersionComponents[0], minor: normalVersionComponents[1], patch: normalVersionComponents[2], preRelease: parsedInfo, metadata: mdata)))
            }
        }
        
    }
}


// MARK: Helpers

/**
Parses a normal version string and returns the result as an array of integers.

A normal version string is a string in the "M.m.p" format. It MUST consist of three dot-separated
integers.

:param: string the version string to parse.
:return: the Int values of the individual components, or a descriptive error.
*/
func parseNormalVersionString(string:String) -> Result<[Int], String> {
    let components = string.componentsSeparatedByString(".")
    
    var results = [Int]()
    for str in components {
        if let num = intFromString(str) {
            results += [num]
        } else {
            return failure("String \"\(str)\" could not be parsed as a number in normal version: \"\(string)")
        }
    }
    
    if results.count != 3 {
        return failure("Normal version must be in M.m.p format, where each of M, m, and p are integers. Passed normal version was: \(string)")
    }
    
    return success(results)
}

func parsePreReleaseInfo(info:String) -> Result<[String], String> {
    /* Divide into components */
    let components = info.componentsSeparatedByString(".")
    
    for str in components {
        if !(str =~ /"^[0-9a-zA-Z\\-]+$") {
            return failure("A component of pre-release info string \"\(info)\" is not in the required character set: [0-9a-zA-S\\-]")
        }
    }
    
    return success(components)
}

func parseMetadata(metadata:String) -> Result<String, String> {
    /* Divide into components */
    let components = metadata.componentsSeparatedByString(".")
    for str in components {
        if !(str =~ /"^[0-9a-zA-Z\\-]+$") {
            return failure("A component of metadata string \"\(metadata)\" is not in the required character set: [0-9a-zA-Z\\-]")
        }
    }
    
    return success(metadata)
}

/**
 Returns a positive integer if one can be parsed from the string, or nil.

 :param: str the string
 :return: the integer, if possible.
*/
public func intFromString(str:String) -> Int? {
    let int = (str as NSString).integerValue
    if int < 0 || ((int == 0) && !(str =~ /"^0+$")) {
        return nil
    }
    
    return int
}

