//
//  AppDelegate.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var navigationController: UINavigationController?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Create application window
    window = UIWindow(frame: UIScreen.main.bounds)

    //Create facts list view controller
    let viewController = ListViewController()
    navigationController = UINavigationController(rootViewController: viewController)

    // Set navigation controller as rootview controller.
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    return true
  }

}
