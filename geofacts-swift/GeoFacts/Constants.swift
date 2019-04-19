///
///  Constants.swift
///  GeoFacts
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 12/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import UIKit

//
// Constans for app text, font, error, constraints
//
struct Constants {
  static let titleFont = CGFloat(24)
  static let titleFontiPad = CGFloat(24)
  
  static let mediumFont = CGFloat(17)
  static let smallFont = CGFloat(14)
  
  static let mediumFontiPad = CGFloat(25)
  static let smallFontiPad = CGFloat(20)
  
  static let defaultLines = 0
  static let imageRadius = CGFloat(3)
  
  static let loadingText = "Loading..."
  static let refreshText =  "Refreshing facts"
  static let okAlertText = "Ok"
  static let downloadQueueName = "Download queue"
  
  static let titleLabelIdentifier = "titeLabel"
  static let factImageIdentifier = "factImageView"
  static let descriptionLabelIdentifier = "descriptionLabel"
  static let contentViewIdentifier = "galleryContentView"
  
  static let cellPadding = CGFloat(10)
  static let estimatedRowHeight = CGFloat(120)
  static let titleHeight = CGFloat(40)
  
  struct DeviceType {
    static let iPhone = "iPhone"
  }
  
  struct ErrorDomain {
    static let invalidRequest = "Invalid Request"
    static let invalidData = "Invalid Data"
    static let serviceError = "Network Error"
  }
  
  struct ErrorCode {
    static let successCode = 200
    static let invalidRequest = 400
    static let invalideResponse = 404
  }
  
  struct ErrorMessage {
    static let invalidRequest = "Request is invalid, Please verify the request."
    static let invalidData = "Response invalid, please try after some time."
    static let serviceError = "Network Service failed, please try after some time."
  }
  
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
