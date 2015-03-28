//
//  Regex.swift
//  SemverKit
//
//  Created by Salazar, Alexandros on 9/15/14.
//  Copyright (c) 2014 nomothetis. All rights reserved.
//

import Foundation

/**
 Simple defaults for regular expressions.
 */


/**
 Creates a regular expression with no error support and NSRegularExpressionOptions.DotMatchesLineSeparators

 :param: pattern the pattern to create the regex from.
 :return: a regular expression.
 */
prefix operator / {}
prefix func /(pattern:String) -> NSRegularExpression {
    var options: NSRegularExpressionOptions =
    NSRegularExpressionOptions.DotMatchesLineSeparators
    
    return NSRegularExpression(pattern:pattern,
        options:options,
        error:nil)!
}

/**
 Checks if the regular expression matches the regex.
 
 :param: string the string to match the regec against.
 :param: regex the regular expression to match against the string.
 :return: `true` if the regex matches, and `false` if it does.
 */
infix operator =~ {}
func =~(string: String, regex: NSRegularExpression) -> Bool {
    let matches = regex.numberOfMatchesInString(string, options: nil, range: NSMakeRange(0, count(string)))
    return matches > 0
}
