///
///  ImageDownloadHelper.swift
///  GeoFacts
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 13/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import UIKit

//
// Facts list webservice protocal and implementations, Imagedownload operations.
//
protocol ImageDownloadHelperProtocol {
  func startDownload(factsCellViewModel: FactsCellViewModel, at indexPath: IndexPath,
                     completion: @escaping () -> Void)
}

class ImageDownloadHelper: ImageDownloadHelperProtocol {
  let pendingOperations = PendingOperations()
  var downloader: ImageDownloader!
  
  static let imageCache = NSCache<NSString, UIImage>()
  
  static var shared: ImageDownloadHelper = {
    let imageDownloader = ImageDownloadHelper()
    return imageDownloader
  }()
  
  // sart image download
  func startDownload(factsCellViewModel: FactsCellViewModel, at indexPath: IndexPath,
                     completion: @escaping () -> Void) {
    DebugLog.print("Download Image")
    guard pendingOperations.downloadsInProgress[indexPath] == nil else {
      return
    }
    
    downloader = ImageDownloader(factsCellViewModel: factsCellViewModel)
    downloader.completionBlock = completion
    
    pendingOperations.downloadsInProgress[indexPath] = downloader
    pendingOperations.downloadQueue.addOperation(downloader)
    
  }
  
  // Get image from cache
  func getImage(factsCellViewModel: FactsCellViewModel, completion: @escaping (UIImage?) -> Void) {
    if let url = factsCellViewModel.imageUrl,
      let image = ImageDownloadHelper.imageCache.object(forKey: url.absoluteString as NSString) {
      DebugLog.print("Cached Image")
      factsCellViewModel.image = image
      factsCellViewModel.imageState = .downloaded
      completion(image)
    } else {
      completion(nil)
    }
  }
  
  func suspendAllOperations() {
    pendingOperations.downloadQueue.isSuspended = true
  }
  
  func resumeAllOperations() {
    pendingOperations.downloadQueue.isSuspended = false
  }
}

// MARK: - PendingOperations

//
// opertions pending download
//
class PendingOperations {
  lazy var downloadsInProgress: [IndexPath: Operation] = [:]
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = Constants.downloadQueueName
    queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
    return queue
  }()
}

// MARK: - ImageDownloader operation

//
// opertions pending download
//
class ImageDownloader: Operation {
  let urlSession: URLSession = URLSession.shared
  let factsCellViewModel: FactsCellViewModel
  
  init(factsCellViewModel: FactsCellViewModel) {
    self.factsCellViewModel = factsCellViewModel
  }
  
  override func main() {
    if isCancelled {
      return
    }
    // image url to download image
    guard let imageUrl = factsCellViewModel.imageUrl else {
      factsCellViewModel.imageState = .failed
      factsCellViewModel.image =  #imageLiteral(resourceName: "failedImage")
      return
    }
    // data with the contents of url
    guard let imageData = try? Data(contentsOf: imageUrl) else {
      // failed - no data
      factsCellViewModel.imageState = .failed
      factsCellViewModel.image =  #imageLiteral(resourceName: "failedImage")
      return
    }
    
    if isCancelled {
      return
    }
    if !imageData.isEmpty,
      let image = UIImage(data: imageData) {
      // image created from data
      factsCellViewModel.image = image
      ImageDownloadHelper.imageCache.setObject(image,
                                               forKey: imageUrl.absoluteString as NSString)
      factsCellViewModel.imageState = .downloaded
    } else {
      // failed - no image data
      factsCellViewModel.imageState = .failed
      factsCellViewModel.image =  #imageLiteral(resourceName: "failedImage")
    }
  }
}
