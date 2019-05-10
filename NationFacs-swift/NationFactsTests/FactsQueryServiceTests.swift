//
//  FactsQueryServiceTests.swift
//  NationFactsTests
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import XCTest
@testable import NationFacts

// Network service test
class FactsQueryServiceTests: XCTestCase {
  var factsQueryService: FactsQueryService!

  override func setUp() {
    super.setUp()
    factsQueryService = FactsQueryService()
  }

  override func tearDown() {
    factsQueryService = nil
    super.tearDown()
  }

  func testFactsQueryServiceSuccess() {
    let endPointUrl = ConfigurationManager.shared.environment.urlEndPoint
    let successTestExpectation = expectation(description: "ServiceSuccess")

    factsQueryService.getFactsList(from: endPointUrl,
                                   success: { (facts) in
                                    XCTAssertNotNil(facts, "response success with valid facts data")
                                    successTestExpectation.fulfill()
    },
                                   failure: { (error) in
                                    XCTAssertNil(error, "error in response")
                                    successTestExpectation.fulfill()
    })
    waitForExpectations(timeout: 30) { (error) in
      if let errorValue = error {
        XCTAssertTrue(false, "Error: \(String(describing: errorValue))")
      }
    }
  }
}

// Mock service tests

// Mock service class for success test case
class FactsQueryMockServieSuccess: FactsQueryProrocol {

  func getFactsList(from urlEndPoint: String,
                    success: @escaping FactsQuerySuccessHandler,
                    failure: @escaping FactsQueryFailureHandler) {
    let factsOne = FactsRecord(title: "FactOne title",
                               description: "FactOne Description",
                               imageHref: "http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png")
    let factsTwo = FactsRecord(title: "FactTwo title",
                               description: "FactTwo Description",
                               imageHref: "http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png")
    let factsData = FactsData(title: "Test FatcsList", rows: [factsOne, factsTwo])
    success(factsData)
  }
}

// Mock service for failure test case
class FactsQueryMockServieFailure: FactsQueryProrocol {

  func getFactsList(from urlEndPoint: String,
                    success: @escaping FactsQuerySuccessHandler,
                    failure: @escaping FactsQueryFailureHandler) {
    let error = NSError(domain: Constants.ErrorDomain.invalidRequest,
                        code: Constants.Status.invalidRequest, userInfo: nil)
    failure(error)
  }
}

class FactsQueryServiceMockTests: XCTestCase {
  var factsQueryMockServiceSuccess: FactsQueryMockServieSuccess!
  var factsQueryMockServiceFailure: FactsQueryMockServieFailure!

  override func setUp() {
    super.setUp()
    factsQueryMockServiceSuccess = FactsQueryMockServieSuccess()
    factsQueryMockServiceFailure = FactsQueryMockServieFailure()
  }

  override func tearDown() {
    factsQueryMockServiceSuccess = nil
    factsQueryMockServiceFailure = nil
    super.tearDown()
  }

  func testGeoFactsMockServiceSuccess() {
    let endPointUrl = ConfigurationManager.shared.environment.urlEndPoint
    let successExpectation = expectation(description: "ServiceSuccess")

    factsQueryMockServiceSuccess.getFactsList(from: endPointUrl,
                                              success: { (facts) in
                                                XCTAssertNotNil(facts, "response success: test failed")
                                                successExpectation.fulfill()
    },
                                              failure: { (error) in
                                                successExpectation.fulfill()
                                                XCTAssertNil(error, "test failed")
    })

    waitForExpectations(timeout: 30) { error in
      if let errorValue = error {
        XCTAssertTrue(false, "Error: \(String(describing: errorValue))")
      }
    }
  }

  func testGeoFactsMockServiceFailure() {
    let endPointUrl = "https://dl.dropboxusercontent.com/SomeInvalide=path"
    let failureExpectation = expectation(description: "ServiceFailure")

    factsQueryMockServiceFailure.getFactsList(from: endPointUrl,
                                              success: { (facts) in
                                                XCTAssertNil(facts, "test failed")
                                                failureExpectation.fulfill()
    }, failure: { (error) in
      XCTAssertNotNil(error, "error in response: test failed")
      failureExpectation.fulfill()
    })

    waitForExpectations(timeout: 30) { error in
      if let errorValue = error {
        XCTAssertTrue(false, "Error: \(String(describing: errorValue))")
      }
    }
  }
}
