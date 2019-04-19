///
///  GeoFactsViewControllerTests.swift
///  GeoFactsTests
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 12/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import XCTest
@testable import GeoFacts

//Facts list viewcontroller test cases for viewModel, observable, operations and scrollView
class GeoFactsViewControllerTests: XCTestCase {
  var geoFactsListViewController: GeoFactsListViewController!
  
  override func setUp() {
    super.setUp()
    geoFactsListViewController = GeoFactsListViewController()
    geoFactsListViewController.initRefreshController()
    geoFactsListViewController.initBinding()
  }
  
  override func tearDown() {
    geoFactsListViewController = nil
    super.tearDown()
  }
  
  func testLoadingFactsList() {
    XCTAssertNotNil(geoFactsListViewController.observables, "Observable not initailized")
    XCTAssertNotNil(geoFactsListViewController.viewModel, "View Model not initailized")
    geoFactsListViewController.viewModel.start()
  }
  
  func testRefreshFactsList() {
    XCTAssertNotNil(geoFactsListViewController.observables, "Observable not initailized")
    XCTAssertNotNil(geoFactsListViewController.viewModel, "View Model not initailized")
    geoFactsListViewController.refresh()
    geoFactsListViewController.endRefresh()
    geoFactsListViewController.observables.isServiceFailed.value = true
  }
  
  func testPendingOperations() {
    ImageDownloadHelper.shared.suspendAllOperations()
    XCTAssert(ImageDownloadHelper.shared.pendingOperations.downloadQueue.isSuspended == true)
    ImageDownloadHelper.shared.resumeAllOperations()
    XCTAssert(ImageDownloadHelper.shared.pendingOperations.downloadQueue.isSuspended == false)
  }
  
  func testScrollView() {
    let scrollView = geoFactsListViewController.tableView
    geoFactsListViewController.scrollViewWillBeginDragging(scrollView)
    geoFactsListViewController.scrollViewDidEndDragging(scrollView, willDecelerate: false)
    geoFactsListViewController.scrollViewDidEndDecelerating(scrollView)
    XCTAssert(true, "Scroll view test")
  }
}
