//
//  FactsQueryService.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import Foundation

typealias FactsQuerySuccessHandler = (FactsData?) -> Void
typealias FactsQueryFailureHandler = (NSError?) -> Void

protocol FactsQueryProrocol {

  func getFactsList(from urlEndPoint: String, success: @escaping FactsQuerySuccessHandler,
                    failure: @escaping FactsQueryFailureHandler)
}

class FactsQueryService: FactsQueryProrocol {
  // Url session with defaulr configuration
  let defaultSession = URLSession(configuration: .default)
  var dataTask: URLSessionDataTask?

  func getFactsList(from urlEndPoint: String, success: @escaping FactsQuerySuccessHandler,
                    failure: @escaping FactsQueryFailureHandler) {
    // cancel existing tasks before starting new get facts task
    dataTask?.cancel()

    // Create URL from string
    guard let requestUrl = URL(string: urlEndPoint) else {
      let error = NSError(domain: Constants.ErrorDomain.invalidRequest,
                          code: Constants.Status.invalidRequest, userInfo: nil)
      failure(error)
      return
    }

    // create data task with completion handler
    dataTask = defaultSession.dataTask(with: requestUrl) { data, response, error in
      defer { self.dataTask = nil }

      DebugLog.print("response data: \(String(describing: response))")

      // handle the response or error
      if let error = error {
        DebugLog.print("error: \(error)")
        failure(error as NSError)
      } else if let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == Constants.Status.success {
        // Cast result value to Json String object
        let stringData = String(data: data, encoding: String.Encoding.isoLatin1)
        DebugLog.print("Json String Data: \(String(describing: stringData))")
        // Make UTF8 data Json string
        guard let utfData = stringData?.data(using: String.Encoding.utf8) else {
          let error = NSError(domain: Constants.ErrorDomain.invalidData,
                              code: Constants.Status.invalidResponse, userInfo: nil)
          DebugLog.print(error)
          return
        }
        // Decode json data to FactsData model object
        do {
          let jsonDecoder = JSONDecoder()
          var decodedFactsData = FactsData()
          decodedFactsData = try jsonDecoder.decode(FactsData.self, from: utfData)
          DebugLog.print("Decoded Facts Json: \(decodedFactsData)")
          success(decodedFactsData)
        } catch let error as NSError {
          failure(error)
          DebugLog.print("JSON Decoder error: \(error)")
        }
      }
    }
    // start the task
    dataTask?.resume()
  }
}
