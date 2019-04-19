///
///  GeoFactsWebServiceTests.swift
///  GeoFactsTests
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 10/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import XCTest
@testable import GeoFacts

//Web service test cases
class GeoFactsWebServiceTests: XCTestCase {
  var geoFactsService: GeoFactsService!
  
  override func setUp() {
    super.setUp()
    geoFactsService = GeoFactsService()
  }
  
  override func tearDown() {
    geoFactsService = nil
    super.tearDown()
  }
  
  func testGeoFactsServiceSuccess() {
    let endPointUrl = ConfigurationManager.shared.environment.urlEndPoint
    let successExpectation = expectation(description: "ServiceSuccess")
    
    geoFactsService.getFactsJsonData(urlEndPoint: endPointUrl) { (response, error) in
      XCTAssertNil(error, "error is nil")
      XCTAssertNotNil(response, "response success with valid facts data")
      successExpectation.fulfill()
    }
    
    waitForExpectations(timeout: 30) { error in
      if let errorValue = error {
        XCTAssertTrue(false, "Error: \(String(describing: errorValue))")
      }
    }
  }
  
  func testGeoFactsServiceFailure() {
    let endPointUrl = "https://dl.dropboxusercontent.com/SomeInvalide=path"
    let failureExpectation = expectation(description: "ServiceFailure")
    
    geoFactsService.getFactsJsonData(urlEndPoint: endPointUrl) { (response, error) in
      XCTAssertNotNil(error, "error in response")
      XCTAssertNil(response, "response failed with nil data")
      failureExpectation.fulfill()
    }
    
    waitForExpectations(timeout: 30) { error in
      if let errorValue = error {
        XCTAssertTrue(false, "Error: \(String(describing: errorValue))")
      }
    }
  }
  
}
