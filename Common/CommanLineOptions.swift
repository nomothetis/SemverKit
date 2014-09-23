//
//  CommanLineOptions.swift
//  SemverKit
//
//  Utilities to support command-line requests.
//
//  Created by Salazar, Alexandros on 9/23/14.
//  Copyright (c) 2014 nomothetis. All rights reserved.
//

import Foundation

protocol Optionable {
    // nothing to add
}

func parseNormalizedIncrementingOptions(options:[String]) -> (Version -> () -> Version)? {
    let relevantOptions = options.reduce((nil as Optional<VersionType>, PrereleaseType.None)) { memo, val in
        switch val {
        case "--alpha":
            return (memo.0, PrereleaseType.Alpha)
        case "--beta":
            return (memo.0, PrereleaseType.Beta)
        case "--major":
            return (VersionType.Major, memo.1)
        case "--minor":
            return (VersionType.Minor, memo.1)
        case "--patch":
            return (VersionType.Patch, memo.1)
        case "--stable":
            return (VersionType.Stable, PrereleaseType.None)
        default:
            break
        }
        return memo
    }
    
    return relevantOptions.0.map { (versionType:VersionType) -> (Version -> () -> Version) in
        return parseIncrementingOption(versionType, relevantOptions.1)
    }
}

enum VersionType {
    case Major, Minor, Patch, Stable
}

enum PrereleaseType {
    case Alpha, Beta, None
}

func parseIncrementingOption(major:VersionType, preRelease:PrereleaseType) -> Version -> () -> Version {
        switch (major, preRelease) {
        case (VersionType.Major, PrereleaseType.None):
            return Version.nextMajorVersion
        case (VersionType.Minor, PrereleaseType.None):
            return Version.nextMinorVersion
        case (VersionType.Patch, PrereleaseType.None):
            return Version.nextPatchVersion
        case (VersionType.Major, PrereleaseType.Beta):
            return Version.nextMajorBetaVersion
        case (VersionType.Minor, PrereleaseType.Beta):
            return Version.nextMinorBetaVersion
        case (VersionType.Patch, PrereleaseType.Beta):
            return Version.nextPatchBetaVersion
        case (VersionType.Major, PrereleaseType.Alpha):
            return Version.nextMinorAlphaVersion
        case (VersionType.Minor, PrereleaseType.Alpha):
            return Version.nextMajorAlphaVersion
        case (VersionType.Patch, PrereleaseType.Alpha):
            return Version.nextPatchAlphaVersion
        default:
            return Version.nextStableVersion
        }
}