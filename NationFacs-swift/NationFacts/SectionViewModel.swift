//
//  SectionViewModel.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 02/05/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import Foundation

//table view row geniric model
protocol RowViewModel {}

//table view section generic model
struct SectionViewModel {
  let rowViewModels: [RowViewModel]
}
