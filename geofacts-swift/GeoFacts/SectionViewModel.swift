///
///  SectionViewModel.swift
///  GeoFacts
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 11/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import Foundation

//table view row geniric model
protocol RowViewModel {}

//table view section generic model
struct SectionViewModel {
  let rowViewModels: [RowViewModel]
}
