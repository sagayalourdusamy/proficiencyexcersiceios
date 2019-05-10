//
//  ConfigurationManager.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import Foundation

final class ConfigurationManager {

  static let shared = ConfigurationManager()
  private init() {
    //private init
  }

  lazy var environment: Environment = {
    //default environment, can be extended for more environments if needed.
    return Environment.dev
  }()
}

enum Environment: String {
  case dev = "Development"

  var urlEndPoint: String {
    switch self {
    case .dev: return "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    }
  }
}
