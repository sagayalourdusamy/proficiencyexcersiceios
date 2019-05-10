//
//  Constants.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import UIKit

struct Constants {
  static let loadingText = "Loading..."
  static let loadingDescription = "Please wait"
  static let okAlertText = "Ok"
  static let refreshText =  "Refreshing facts"
  static let downloadQueueName = "Image Download queue"

  static let defaultLines = 0
  static let imageRadius = CGFloat(3)

  static let cellPadding = CGFloat(5)
  static let estimatedRowHeight = CGFloat(120)
  static let titleHeight = CGFloat(40)

  enum ErrorDomain {
    static let invalidRequest = "Invalid Request"
    static let invalidData = "Invalid Data"
    static let serviceError = "Network Error"
  }

  enum Status {
    static let success = 200
    static let invalidRequest = 400
    static let invalidResponse = 404
  }

  enum ErrorMessage {
    static let invalidRequest = "Request is invalid, Please verify the request."
    static let invalidData = "Response invalid, please try after some time."
    static let serviceError = "Network Service failed, please try after some time."
  }

  enum DeviceType {
    static let iPhone = "iPhone"
  }
}
