//
//  VersionBump.swift
//  SemverKit
//
//  Created by Salazar, Alexandros on 9/15/14.
//  Copyright (c) 2014 nomothetis. All rights reserved.
//

import Foundation

/**
 An extension to allow semantic incrementation of versions, including support for alpha and beta
 versions.
 */
extension Version {
    /**
    Bumps the major number by one; zeros and nils out the rest.
    
    :return: a new version with a bumped major version.
    */
    public func nextMajorVersion() -> Version {
        return Version(major: self.major + 1, minor: 0, patch: 0, preRelease: PreReleaseInfo.None)
    }
    
    /**
    Bumps the minor number by one; zeros and nils out all less-significant values.
    
    :return: a new version with a bumped minor version.
    */
    public func nextMinorVersion() -> Version {
        return Version(major: self.major, minor: self.minor + 1, patch: 0, preRelease: nil, metadata: nil)
    }
    
    /**
    Bumps the patch number by one; zeros and nils out all less-significant values.
    
    :return: a new version with a bumped patch version.
    */
    public func nextPatchVersion() -> Version {
        return Version(major: self.major, minor: self.minor, patch: self.patch + 1, preRelease: nil)
    }
    
    /**
    Returns the next major alpha version.
    
    The next major alpha version of version `v1` is defined as the smallest version `v2 > v1` with
    - A patch number of 0
    - A minor number of 0
    - A pre-release of alpha.X, where X is an integer
    
    Examples:
    - 2.3.5         -> 3.0.0-alpha.0
    - 2.0.5         -> 3.0.0-alpha.0
    - 3.0.0         -> 4.0.0-alpha.0
    - 3.0.0-alpha.0 -> 3.0.0-alpha.1
    - 3.0.0-beta.1  -> 4.0.0-alpha.0
    - 3.0.0-alpha   -> 3.0.0-alpha.0
    - 3.0.0-234     -> 3.0.0-alpha.0
    - 3.0.0-tim     -> 4.0.0-alpha.0
    
    :return: a new version with bumped major version, and an alpha prerelease of 0.
    */
    public func nextMajorAlphaVersion() -> Version {
        switch self.preRelease {
        case PreReleaseInfo.None:
            return Version(major: self.major + 1, minor: 0, patch: 0, preRelease:.Alpha(0))
        case PreReleaseInfo.Alpha(let alpha):
            if (self.patch == 0) && (self.minor == 0) {
                return Version(major: self.major, minor: 0, patch: 0, preRelease:.Alpha(alpha + 1))
            } else {
                return Version(major: self.major + 1, minor: 0, patch: 0, preRelease:.Alpha(0))
            }
        case PreReleaseInfo.Beta(_):
            return Version(major: self.major + 1, minor: 0, patch: 0, preRelease:.Alpha(0))
        case .Arbitrary(let info):
            if (self.preRelease < PreReleaseInfo.Alpha(0)) {
                return Version(major: self.major, minor: 0, patch: 0, preRelease: .Alpha(0))
            } else {
                return Version(major: self.major + 1, minor: 0, patch: 0, preRelease: .Alpha(0))
            }
        }
    }
    
    /**
    Returns the next minor alpha version.
    
    The next minor alpha version of a version `v1` is defined as the smallest version `v2 > v1` with
    - A patch number of 0.
    - An pre-release of alpha.X, where X is an integer.
    
    Examples:
    - 2.3.5         -> 2.4.0-alpha.0
    - 2.3.0         -> 2.4.0-alpha.0
    - 2.3.5-alpha.3 -> 2.4.0-alpha.0
    - 2.3.0-alpha.3 -> 2.3.0-alpha.4
    - 2.3.0-alpha.a -> 2.4.0-alpha.0 (digits have lower priority than strings)
    - 2.3.0-12      -> 2.3.0-alpha.0
    - 2.3.0-beta.3  -> 2.4.0-alpha.0
    - 2.3.0-alpha   -> 2.3.0-alpha.0
    
    :return: the next minor alpha version.
    */
    public func nextMinorAlphaVersion() -> Version {
        switch self.preRelease {
        case PreReleaseInfo.None:
            return Version(major: self.major, minor: self.minor + 1, patch: 0, preRelease:.Alpha(0))
        case PreReleaseInfo.Alpha(let alpha):
            if (self.patch == 0) {
                return Version(major: self.major, minor: self.minor, patch: self.patch, preRelease:.Alpha(alpha + 1))
            } else {
                return Version(major: self.major, minor: self.minor + 1, patch: 0, preRelease:.Alpha(0))
            }
        case PreReleaseInfo.Beta(_):
            return Version(major: self.major, minor: self.minor + 1, patch: 0, preRelease:.Alpha(0))
        case .Arbitrary(let info):
            if (self.patch != 0) {
                return Version(major: self.major, minor: self.minor, patch: self.patch, preRelease:.Alpha(0))
            } else if (self.preRelease < PreReleaseInfo.Alpha(0)) {
                return Version(major: self.major, minor: self.minor, patch: self.patch, preRelease: .Alpha(0))
            } else {
                return Version(major: self.major, minor: self.minor + 1, patch: 0, preRelease: .Alpha(0))
            }
        }
    }
    
    /**
    Returns the next patch alpha version.
    
    The next patch alpha version of a version `v1` is defined as the smallest version `v2 > v1`
    with:
    - A pre-release in the form alpha.X where X is an integer
    
    Examples:
    - 2.0.0         -> 2.0.1-alpha.0
    - 2.0.1-alpha.0 -> 2.0.1-alpha.2
    - 2.0.1-beta.3  -> 2.0.2-alpha.0
    - 2.0.1-alpha   -> 2.0.2-alpha.0
    
    :return: the next patch alpha version.
    */
    public func nextPatchAlphaVersion() -> Version {
        switch self.preRelease {
        case PreReleaseInfo.None:
            return Version(major: self.major, minor: self.minor, patch: self.patch + 1, preRelease:.Alpha(0))
        case PreReleaseInfo.Alpha(let alpha):
            return Version(major: self.major, minor: self.minor, patch: self.patch, preRelease:.Alpha(alpha + 1))
        case PreReleaseInfo.Beta(_):
            return Version(major: self.major, minor: self.minor, patch: self.patch + 1, preRelease:.Alpha(0))
        case .Arbitrary(let info):
            if (self.preRelease < PreReleaseInfo.Alpha(0)) {
                return Version(major: self.major, minor: self.minor, patch: self.patch, preRelease: .Alpha(0))
            } else {
                return Version(major: self.major, minor: self.minor, patch: self.patch + 1, preRelease: .Alpha(0))
            }
        }
    }
    
    /**
    Returns the next major beta version.
    
    The next major beta version of a version `v1` is defined as the smallest version `v2 > v1` with:
    - A minor number of 0
    - A patch number of 0
    - A pre-release of beta.X, where X is an integer
    
    Examples:
    2.3.5         -> 3.0.0-beta.0
    2.3.5-alpha.0 -> 3.0.0-beta.0
    3.0.0-alpha.7 -> 3.0.0-beta.0
    3.0.0-beta.7  -> 3.0.0-beta.8
    3.0.0-tim     -> 4.0.0-beta.0
    3.0.0-123     -> 3.0.0-beta0
    
    :return: the next major beta version.
    */
    public func nextMajorBetaVersion() -> Version {
        switch self.preRelease {
        case .None:
            return Version(major: self.major + 1, minor: 0, patch: 0, preRelease: .Beta(0))
        case .Alpha(_):
            if self.minor == 0 && self.patch == 0 {
                return Version(major: self.major, minor: 0, patch: 0, preRelease:.Beta(0))
            } else {
                return Version(major: self.major + 1, minor: 0, patch: 0, preRelease:.Beta(0))
            }
        case .Beta(let int):
            if (self.minor == 0 && self.patch == 0) {
                return Version(major: self.major, minor: 0, patch: 0, preRelease:.Beta(int + 1))
            } else {
                return Version(major: self.major + 1, minor: 0, patch: 0, preRelease:.Beta(0))
            }
        case .Arbitrary(let arr):
            if (self.preRelease < .Beta(0)) {
                return Version(major: self.major, minor: 0, patch: 0, preRelease: .Beta(0))
            } else {
                return Version(major: self.major + 1, minor: 0, patch: 0, preRelease: .Beta(0))
            }
        }
    }
    
    /**
    Returns the next minor beta version.
    
    The next minor beta version of a version `v1` is defined as the smallest version `v2 > v1` with:
    - A patch number of 0
    - A pre-release of beta.X, where X is an integer
    
    Examples:
    - 2.3.5         -> 2.4.0-beta.0
    - 2.2.0         -> 2.3.0-beta.0
    - 2.5.0-alpha.3 -> 2.5.0-beta.0
    - 2.7.0-beta.3  -> 2.7.0-beta.4
    - 8.3.0-final   -> 8.4.0-beta.0
    - 8.4.0-45      -> 8.4.0-beta.0
    
    :return: the next minor beta version.
    */
    public func nextMinorBetaVersion() -> Version {
        switch self.preRelease {
        case .None:
            return Version(major: self.major, minor: self.minor + 1, patch: 0, preRelease:.Beta(0))
        case .Alpha(_):
            if self.patch == 0 {
                return Version(major: self.major, minor: self.minor, patch: 0, preRelease:.Beta(0))
            } else {
                return Version(major: self.major, minor: self.minor + 1, patch: 0, preRelease:.Beta(0))
            }
        case .Beta(let int):
            if self.patch == 0 {
                return Version(major: self.major, minor: self.minor, patch: 0, preRelease:.Beta(int + 1))
            } else {
                return Version(major: self.major, minor: self.minor + 1, patch: 0, preRelease:.Beta(0))
            }
        case .Arbitrary(let info):
            if self.preRelease < PreReleaseInfo.Beta(0) {
                return Version(major: self.major, minor: self.minor, patch: 0, preRelease:.Beta(0))
            } else {
                return Version(major: self.major, minor: self.minor + 1, patch: 0, preRelease:.Beta(0))
            }
        }
    }
    
    /**
    Returns the next patch beta version.
    
    The next patch beta version of a version `v1` is defined as the smallest version `v2 > v1` where:
    - A pre-release in the form beta.X where X is an integer
    
    Examples:
    - 2.3.5         -> 2.3.6-beta.0
    - 3.4.0-alpha.0 -> 3.4.0-beta.0
    - 3.0.0         -> 3.0.1-beta.0
    - 3.1.0         -> 3.1.1-beta.0
    - 3.1.0-beta.1  -> 3.1.1-beta.2
    - 3.1.0-123     -> 3.1.0-beta.0
    
    :return: the next patch beta version.
    */
    public func nextPatchBetaVersion() -> Version {
        switch self.preRelease {
        case .None:
            return Version(major: self.major, minor: self.minor, patch: self.patch + 1, preRelease:.Beta(0))
        case .Alpha(_):
            return Version(major: self.major, minor: self.minor, patch: self.patch, preRelease:.Beta(0))
        case .Beta(let num):
            return Version(major: self.major, minor: self.minor, patch: self.patch, preRelease: .Beta(num + 1))
        case .Arbitrary(let info):
            if self.preRelease < .Beta(0) {
                return Version(major: self.major, minor: self.minor, patch: self.patch, preRelease:.Beta(0))
            } else {
                return Version(major: self.major, minor: self.minor, patch: self.patch + 1, preRelease:.Beta(0))
            }
        }
    }
    
    /**
    Gets the stable version.
    
    A stabilized version `v1` is the smallest version `v2 > v1` such that there is no prerelease
    or metadata info.
    
    Examples:
    - 3.0.0-alpha.2 -> 3.0.0
    - 3.4.3-beta.0  -> 3.4.3
    
    :return: the stabilized version.
    */
    public func stableVersion() -> Version {
        return Version(major: self.major, minor: self.minor, patch: self.patch, preRelease: PreReleaseInfo.None)
    }

}