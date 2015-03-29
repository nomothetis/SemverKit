# SemverKit — Semantic Versioning in Swift

SemverKit is a pure Swift implementation of the [Semantic Versioning 2.0][semver2] specification.
It includes a parser for version strings, as well as comparison and equality operators. As
an extension, it also includes semantics for incrementing versions, with special support for
alpha and beta pre-release versions.

SemverKit exists for both iOS and OS X, with the OS X version having an eye towards being
useful for the creation of scripts and command-line tools. The OS X framework therefore
includes additional functionality, such as consistent parsing of options.

## Basic Usage

The first point of contact with the API is likely going to be the parser.

```swift
let result1 = parseVersion("2.0.1-alpha.2") // { Success 2.0.1-alpha.2 }
let result2 = parseVersion("a.0.2-alpha.3") // { Failure String "a.0.2" could not be
                                            //   parsed as a number in normal version: "a.0.2" }
```

The parser returns a `Result` type, an enum that is either a `Success` or a `Failure`,
depending on whether or not the parsing was successful. Upon failure, a message describes
the source of the error. A successful parse contains the core type of the library: a `Version`.

`Version` is `Equatable` and `Comparable`, fully implementing the semantics of the spec:

```
 2.0.1 < 2.0.2 < 2.1.0 < 2.2.0 < 3.0.0 < 3.1.0-alpha.0 < 3.1.0-alpha.3 < 3.1.0-beta < 3.1.0-beta.0 < 3.1.0-beta.1 < 3.1.0-lexically-larger < 3.1.0
```

Of course, version metadata is fully supported, but ignored during equality and comparison
operations.

## Extensions

In addition to supporting basic comparison of versions, SemverKit also includes support for
incrementing versions in a consistent manner. A number of methods are defined to support:

* Incrementing normal versions (patch, minor, major)
* Incrementing pre-release versions (to pre-release alpha and beta versions and to normal versions)
* Stabilizing a version

All these methods are prefixed with `next*`, and their return values are uniquely defined. 
For instance, `nextMajorAlphaVersion` defines what it returns as:

> The next major alpha version of version `v1` is defined as the smallest version `v2 > v1` with:
>    - A patch number of 0
>    - A minor number of 0
>    - A pre-release of alpha.X, where X is an integer

This allows for precise semantics, which makes SemverKit suitable for automated versioning.

## Installation

Minimum system requirements:

* Xcode 6.3 β4
* OS X Mavericks 10.10

Steps:

1. Clone this github repository, and build the project.
1. Run the tests, just for sanity. They should all pass.
1. Copy `SemverKit.framework` from the `DerivedData` directoy to `/Library/Frameworks`
  (this will require `sudo` access)

SemverKit should now be available for use from a command line script. The shebang needs
to read:

```swift
#!/usr/bin/env xcrun swift -F /Library/Frameworks
```

This is because the Swift compiler, unlike Clang, doesn't automatically pick up frameworks in
`/Library/Frameworks`.

## Including SemverKit in Other Libraries

Use [Carthage](https://github.com/Carthage/Carthage). SemverKit, of course, uses semantic
versioning, so the corresponding Cartfile line should be:

```
github "nomothetis/SemverKit" == 0.2.0
```

[semver2]: http://semver.org/spec/v2.0.0.html
