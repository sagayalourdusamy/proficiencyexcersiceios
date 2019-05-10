//
//  FactModel.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import Foundation

//Facts Json model
struct FactsData: Decodable {
  var title: String?
  var rows: [FactsRecord]?
}

//Facts row record model
struct FactsRecord: Decodable {
  var title: String?
  var description: String?
  var imageHref: String?
}
