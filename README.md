# SemverKit — Semantic Versioning in Swift

SemverKit is a pure Swift implementation of the [Semantic Versioning 2.0][semver2] specification.
It includes a parser for version strings, as well as comparison and equality operators. As
an extension, it also includes semantics for incrementing versions, with special support for
alpha and beta pre-release versions.

## Basic Usage

The first point of contact with the API is likely going to be the parser.

```swift
let result1 = parseVersion("2.0.1-alpha.2") // { Success 2.0.1-alpha.2 }
let result2 = parseVersion("a.0.2-alpha.3") // { Failure String "a.0.2" could not be
                                            //   parsed as a number in normal version: "a.0.2" }
```

The parser returns a `Result` type, an enum that is either a `Success` or a `Failure`,
depending on whether or not the parsing was successful. Upon failure, a message describes
the source of the error. A successful parse contains the core type of the library: a Version.

Versions are `Equatable` and `Comparable`, fully implementing the semantics of the spec:

```
 2.0.1 < 2.0.2 < 2.1.0 < 2.2.0 < 3.0.0
   < 3.1.0-alpha.0 < 3.1.0-alpha.3 < 3.1.0-beta < 3.1.0-beta.0 < 3.1.0-beta.1
   < 3.1.0-lexically-larger < 3.1.0
```

Of course, version metadata is fully supported, but ignored during equality and comparison
operations.

## Extensions

In addition to supporting basic comparison of versions, SemverKit also includes support for
incrementing versions in a consistent manner. A number of methods are defined to support:

* Incrementing normal versions (patch, minor, major).
* Incrementing pre-release versions (to other pre-release and to stable versions)
* Stabilizing a version.

All these methods are prefixed with `next*`, and their return values are uniquely defined
attached. For instance, `nextMajorAlphaVersion` defines what it returns as:

> The next major alpha version of version `v1` is defined as the smallest version `v2 > v1` with:
>    - A patch number of 0
>    - A minor number of 0
>    - A pre-release of alpha.X, where X is an integer

This allows for precise semantics, which makes SemverKit suitable for automated versioning.

[semver2]: http://semver.org/spec/v2.0.0.html
