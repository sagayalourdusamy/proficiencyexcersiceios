//
//  FactCellViewModel.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 02/05/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import UIKit

enum ImageState {
  case new, downloaded, failed
}

//Facts cell view model
class FactCellViewModel: RowViewModel {

  let title: String
  let desc: String
  var imageUrl: URL?
  //Initialized with Place holder image
  var image = #imageLiteral(resourceName: "placeholderImage")
  //image state to check the dowonloaded/falied images
  var imageState = ImageState.new

  init(title: String, desc: String, imageUrl: URL?) {
    self.title = title
    self.desc = desc
    self.imageUrl = imageUrl
  }
}
