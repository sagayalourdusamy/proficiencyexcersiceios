///
///  GeoFactsMockService.swift
///  GeoFactsTests
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 12/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import XCTest
@testable import GeoFacts

// Mock service class for success test case
class GeoFactsListMockServieSuccess: GeoFactsServiceProtocol {
  func getFactsJsonData(urlEndPoint: String, completion: @escaping (FactsData?, NSError?) -> Void) {
    let factsOne = FactsRecord(title: "FactOne title",
                               description: "FactOne Description",
                               imageHref: "http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png")
    let factsTwo = FactsRecord(title: "FactTwo title",
                               description: "FactTwo Description",
                               imageHref: "http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png")
    let factsData = FactsData(title: "Test FatcsList", rows: [factsOne, factsTwo])
    completion(factsData, nil)
  }
}

// Mock service for failure test case
class GeoFactsListMockServieFailure: GeoFactsServiceProtocol {
  func getFactsJsonData(urlEndPoint: String, completion: @escaping (FactsData?, NSError?) -> Void) {
    let error = NSError(domain: Constants.ErrorDomain.invalidRequest,
                        code: Constants.ErrorCode.invalidRequest, userInfo: nil)
    completion(nil, error)
  }
}

// Mock service test cases
class GeoFactsMockServiceTests: XCTestCase {
  var geoMockFactsServiceSuccess: GeoFactsListMockServieSuccess!
  var geoFactsListMockServieFailure: GeoFactsListMockServieFailure!
  
  override func setUp() {
    super.setUp()
    geoMockFactsServiceSuccess = GeoFactsListMockServieSuccess()
    geoFactsListMockServieFailure = GeoFactsListMockServieFailure()
  }
  
  override func tearDown() {
    geoMockFactsServiceSuccess = nil
    geoFactsListMockServieFailure = nil
    super.tearDown()
  }
  
  func testGeoFactsMockServiceSuccess() {
    let endPointUrl = ConfigurationManager.shared.environment.urlEndPoint
    let successExpectation = expectation(description: "ServiceSuccess")
    
    geoMockFactsServiceSuccess.getFactsJsonData(urlEndPoint: endPointUrl) { (response, error) in
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
  
  func testGeoFactsMockServiceFailure() {
    let endPointUrl = "https://dl.dropboxusercontent.com/SomeInvalide=path"
    let failureExpectation = expectation(description: "ServiceFailure")
    
    geoFactsListMockServieFailure.getFactsJsonData(urlEndPoint: endPointUrl) { (response, error) in
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
