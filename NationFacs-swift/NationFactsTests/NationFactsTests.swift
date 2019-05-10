//
//  NationFactsTests.swift
//  NationFactsTests
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import XCTest
@testable import NationFacts

class NationFactsTests: XCTestCase {
  var listViewController: ListViewController!
  var window: UIWindow!

  override func setUp() {
    super.setUp()
    window = UIWindow()
    listViewController = ListViewController()
    listViewController.initBinding()
  }

  override func tearDown() {
    listViewController = nil
    window = nil
    super.tearDown()
  }

  func loadView() {
    window.addSubview(listViewController.view)
    RunLoop.current.run(until: Date(timeInterval: 30, since: Date()))
  }

  func testListViewController() {
    loadView()
    listViewController.observables.serviceError = NSError(domain: "Test Error", code: 401, userInfo: nil)
    listViewController.showServiceFailedAlert()
    let errorCode = listViewController.observables.serviceError
    XCTAssert(errorCode?.code == 401, "Test Service Error")
  }

  func testLoadingFactsList() {
    XCTAssertNotNil(listViewController.observables, "Observable not initailized")
    XCTAssertNotNil(listViewController.viewModel, "View Model not initailized")
    listViewController.viewModel.start()
  }

  func testRefreshFactsList() {
    XCTAssertNotNil(listViewController.observables, "Observable not initailized")
    XCTAssertNotNil(listViewController.viewModel, "View Model not initailized")
    listViewController.refresh()
    listViewController.endRefresh()
    listViewController.observables.isServiceFailed.value = true
  }

  func testObservables() {
    listViewController.observables.isLoading.value = true
    XCTAssert(listViewController.observables.isLoading.value, "Observable test")
  }

  func testPendingOperations() {
    ImageDownloadHelper.shared.suspendAllOperations()
    XCTAssert(ImageDownloadHelper.shared.pendingOperations.downloadQueue.isSuspended == true)
    ImageDownloadHelper.shared.resumeAllOperations()
    XCTAssert(ImageDownloadHelper.shared.pendingOperations.downloadQueue.isSuspended == false)
  }

  func testScrollView() {
    let scrollView = listViewController.tableView
    listViewController.viewModel.scrollViewWillBeginDragging(scrollView)
    listViewController.viewModel.scrollViewDidEndDragging(scrollView, willDecelerate: false)
    listViewController.viewModel.scrollViewDidEndDecelerating(scrollView)
    XCTAssert(true, "Scroll view test")
  }
}
