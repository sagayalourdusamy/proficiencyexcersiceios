///
///  Extensions.swift
///  GeoFacts
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 11/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import UIKit

///
/// UIView extension
///
/// - edgeConstraints: convenient method which generates and returns edge constraints
///
public extension UIView {
  /// Generating top, left, bottom and right constraints to superview's edge
  public func edgeConstraints(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> [NSLayoutConstraint] {
    return [
      self.leftAnchor.constraint(equalTo: self.superview!.leftAnchor, constant: left),
      self.rightAnchor.constraint(equalTo: self.superview!.rightAnchor, constant: -right),
      self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: top),
      self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: -bottom)
    ]
  }
}

///
/// UITableViewCell extension
///
/// - cellIdentifier: returns cellIdentfier string
///
public extension UITableViewCell {
  /// Generated cell identifier derived from class name
  public static func cellIdentifier() -> String {
    return String(describing: self)
  }
}

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
