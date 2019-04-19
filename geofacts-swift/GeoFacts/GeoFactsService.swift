///
///  GeoFactsService.swift
///  GeoFacts
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 10/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import Foundation
import Alamofire

//
// Facts list webservice protocal and implementations.
//
protocol GeoFactsServiceProtocol {
  func getFactsJsonData(urlEndPoint: String, completion: @escaping (FactsData?, NSError?) -> Void)
}

class GeoFactsService: GeoFactsServiceProtocol {
  
  func getFactsJsonData(urlEndPoint: String, completion: @escaping (FactsData?, NSError?) -> Void) {
    //Create URL from string
    guard let requestUrl = URL(string: urlEndPoint) else {
      let error = NSError(domain: Constants.ErrorDomain.invalidRequest,
                          code: Constants.ErrorCode.invalidRequest, userInfo: nil)
      completion(nil, error)
      return
    }
    //Create Alamofire request to fetch the facts json data
    let request = Alamofire.request(requestUrl,
                                    method: Alamofire.HTTPMethod.get,
                                    parameters: nil,
                                    encoding: JSONEncoding.default,
                                    headers: nil)
    request.responseData { response in
      //Validate respose for success, call back commpletion handler on receiving error resonse
      guard response.result.isSuccess else {
        let error = response.result.error as NSError?
        completion(nil, error)
        return
      }
      //Convert the response data to the FactsData model
      if let responseData = response.result.value {
        //Covert result value to String object
        let stringData = String(data: responseData, encoding: String.Encoding.isoLatin1)
        DebugLog.print("Json Data: \(String(describing: stringData))")
        //Convert to UTF8 data
        guard let utfData = stringData?.data(using: String.Encoding.utf8) else {
          let error = NSError(domain: Constants.ErrorDomain.invalidData,
                              code: Constants.ErrorCode.invalideResponse, userInfo: nil)
          completion(nil, error)
          return
        }
        do {
          let jsonDecoder = JSONDecoder()
          var decodedFactsData = FactsData()
          //Decode the UTF8 data to FactsData model object
          decodedFactsData = try jsonDecoder.decode(FactsData.self, from: utfData)
          completion(decodedFactsData, nil)
        } catch let error as NSError {
          completion(nil, error)
        }
      }
    }
  }
}
