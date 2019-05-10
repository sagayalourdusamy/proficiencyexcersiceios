//
//  Observable.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 02/05/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import Foundation

//
// Generic class for obervable pattern
//
class Observable<T> {
  var value: T {
    didSet {
      DispatchQueue.main.async {
        self.valueChanged?(self.value)
      }
    }
  }

  private var valueChanged: ((T) -> Void)?

  init(value: T) {
    self.value = value
  }

  /// Add closure as an observer and call back the closure imeediately if fireNow = true
  func addObserver(fireNow: Bool = true, _ onChange: ((T) -> Void)?) {
    valueChanged = onChange
    if fireNow {
      onChange?(value)
    }
  }

  func removeObserver() {
    valueChanged = nil
  }

}
