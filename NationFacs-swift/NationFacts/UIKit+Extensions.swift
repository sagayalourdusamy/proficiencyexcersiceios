//
//  UIKit+Extensions.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 01/05/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import UIKit
import MBProgressHUD

//
// UITableViewCell extension
//
// - cellIdentifier: returns cellIdentfier string
//
public extension UITableViewCell {
  /// Generated cell identifier derived from class name
  public static func cellIdentifier() -> String {
    return String(describing: self)
  }
}

//
// UIViewController extension
//
//
extension UIViewController {
  /// - showIndicator: show loading indicator
  func showIndicator(withTitle title: String, description: String) {
    let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
    indicator.label.text = title
    indicator.isUserInteractionEnabled = false
    indicator.detailsLabel.text = description
    indicator.show(animated: true)
  }

  // - hideIndicator: show loading indicator
  func hideIndicator() {
    MBProgressHUD.hide(for: self.view, animated: true)
  }
}
