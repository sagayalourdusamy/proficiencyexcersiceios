//
//  StyleManager.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 01/05/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import UIKit

//
// Constans for app text, error, constraints
//
struct StyleManager {

  static let titleFont = CGFloat(24)
  static let titleFontiPad = CGFloat(28)

  static let mediumFont = CGFloat(17)
  static let smallFont = CGFloat(14)

  static let mediumFontiPad = CGFloat(25)
  static let smallFontiPad = CGFloat(20)

  // app medium font size for fact cell
  static func getMediumFont() -> CGFloat {
    if UIDevice.current.model == Constants.DeviceType.iPhone {
      return mediumFont
    } else {
      return mediumFontiPad
    }
  }

  // app small font size for fact cell
  static func getSmallFont() -> CGFloat {
    if UIDevice.current.model == Constants.DeviceType.iPhone {
      return smallFont
    } else {
      return smallFontiPad
    }
  }

  //font size for view title
  static func getTitleFont() -> CGFloat {
    if UIDevice.current.model == Constants.DeviceType.iPhone {
      return titleFont
    } else {
      return titleFontiPad
    }
  }
}
