//
//  DebugLog.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import Foundation

/// DebugLog type
public struct DebugLog {

  //
  //     print items to the console
  //     - items:      items to print
  //     - separator:  separator between items. Default is space" : "
  //     - terminator: a character inserted at the end of output.
  //
  public static func print(_ items: Any..., separator: String = " : ",
                           terminator: String = "\n", _ file: String = #file,
                           _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
    let filename = file.lastPathComponent.stringByDeletingPathExtension
    var prefix = filename
    prefix += " : \(function)"
    prefix += "[\(line)]"
    let stringItem = items.map { "\($0)" } .joined(separator: separator)
    Swift.print("\(prefix)\(stringItem)", terminator: terminator)
    #endif
  }
}
