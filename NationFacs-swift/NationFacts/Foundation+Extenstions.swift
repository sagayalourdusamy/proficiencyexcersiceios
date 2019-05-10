//
//  Foundation+Extenstions.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import Foundation

//
// String syntax extension
//
// - nsstring: returns cNSString
// - lastPathComponent: last component string
// - stringByDeletingPathExtension: remove path extension from string
//
extension String {
  var nsstring: NSString {
    return self as NSString
  }
  var lastPathComponent: String {
    return nsstring.lastPathComponent
  }
  var stringByDeletingPathExtension: String {
    return nsstring.deletingPathExtension
  }
}
