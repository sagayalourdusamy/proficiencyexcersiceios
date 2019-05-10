//
//  ImageDownloadHelperTests.swift
//  NationFactsTests
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 02/05/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import XCTest
@testable import NationFacts

//Image download helper test cases
class ImageDownloadHelperTests: XCTestCase {

  func testGetImageFromCache() {
    let factCellViewModel = FactCellViewModel(title: "test Image",
                                               desc: "test Desc",
                                               imageUrl: URL(fileURLWithPath: "https\\test.com\test"))
    if let cacheKey = factCellViewModel.imageUrl?.absoluteString as NSString? {
      ImageDownloadHelper.imageCache.setObject(#imageLiteral(resourceName: "failedImage"),
                                               forKey: cacheKey)
    }
    let getImageExpectation = expectation(description: "getImageFromCache")
    ImageDownloadHelper.shared.getImage(factCellViewModel: factCellViewModel) { (image) in
      XCTAssertNotNil(image, "Cache Image failed")
      getImageExpectation.fulfill()
    }

    waitForExpectations(timeout: 5, handler: nil)
    ImageDownloadHelper.imageCache.removeAllObjects()
  }

  func testGetImageFromCacheFail() {
    let factCellViewModel = FactCellViewModel(title: "test Image",
                                               desc: "test Desc",
                                               imageUrl: URL(fileURLWithPath: "https\\test.com\test"))
    let getImageExpectation = expectation(description: "getImageFromCacheFail")
    ImageDownloadHelper.shared.getImage(factCellViewModel: factCellViewModel) { (image) in
      XCTAssertNil(image, "Cache Image")
      getImageExpectation.fulfill()
    }

    waitForExpectations(timeout: 5, handler: nil)
  }
}
