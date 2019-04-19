///
///  GeoFactsListViewController+TableView.swift
///  GeoFacts
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 13/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import UIKit

//
// Facts list table view datasource comformace method implementation,
// Delegate conformance method implementation.
//
extension GeoFactsListViewController {
  
  // MARK: - tableview delegate/datasource methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionViewModel = observables.sectionViewModels.value
    return sectionViewModel.rowViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let sectionViewModel = observables.sectionViewModels.value
    let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: FactsCell.cellIdentifier(), for: indexPath)
    
    if let cell = cell as? FactsCell {
      cell.setup(viewModel: rowViewModel)
      
      if let viewModel = rowViewModel as? FactsCellViewModel {
        if cell.accessoryView == nil {
          let indicator = UIActivityIndicatorView(style: .gray)
          cell.accessoryView = indicator
        }
        var indicator: UIActivityIndicatorView?
        indicator = cell.accessoryView as? UIActivityIndicatorView
        
        switch viewModel.imageState {
        case .downloaded, .failed:
          indicator?.stopAnimating()
        case .new:
          indicator?.startAnimating()
          if !tableView.isDragging && !tableView.isDecelerating {
            getImageFor(factsCellViewModel: viewModel, at: indexPath)
          }
        }
      }
    }
    
    cell.layoutIfNeeded()
    return cell
  }
  
  // MARK: - scrollvoew delegate methods
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    ImageDownloadHelper.shared.suspendAllOperations()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      loadImagesForVisibleCells()
      ImageDownloadHelper.shared.resumeAllOperations()
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    loadImagesForVisibleCells()
    ImageDownloadHelper.shared.resumeAllOperations()
  }
  
  // MARK: Image laod/download methods
  func getImageFor(factsCellViewModel: FactsCellViewModel, at indexPath: IndexPath) {
    ImageDownloadHelper.shared.getImage(factsCellViewModel: factsCellViewModel) { (image) in
      if image != nil {
        DispatchQueue.main.async {
          DebugLog.print("Reload the table view")
          self.tableView.reloadRows(at: [indexPath], with: .none)
        }
      } else {
        self.downloadImageFor(factsCellViewModel: factsCellViewModel, at: indexPath)
      }
    }
  }
  
  func downloadImageFor(factsCellViewModel: FactsCellViewModel, at indexPath: IndexPath) {
    ImageDownloadHelper.shared.startDownload(factsCellViewModel: factsCellViewModel, at: indexPath) {
      if ImageDownloadHelper.shared.downloader.isCancelled {
        return
      }
      DispatchQueue.main.async {
        let pendingOperations = ImageDownloadHelper.shared.pendingOperations
        pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        self.tableView.reloadRows(at: [indexPath], with: .none)
      }
    }
  }
  
  func loadImagesForVisibleCells() {
    if let pathsArray = tableView.indexPathsForVisibleRows {
      let allPendingOperations = Set(ImageDownloadHelper.shared.pendingOperations.downloadsInProgress.keys)
      
      // list pending operations except for visible cells
      var toBeCancelled = allPendingOperations
      let visiblePaths = Set(pathsArray)
      toBeCancelled.subtract(visiblePaths)
      
      // list visible cell operation to be started
      var toBeStarted = visiblePaths
      toBeStarted.subtract(allPendingOperations)
      
      //cancel to be cancelled operations
      for indexPath in toBeCancelled {
        if let pendingDownload = ImageDownloadHelper.shared.pendingOperations.downloadsInProgress[indexPath] {
          pendingDownload.cancel()
        }
        ImageDownloadHelper.shared.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
      }
      
      let sectionViewModel = observables.sectionViewModels.value
      
      //get image and start operation if need for to be started index paths
      for indexPath in toBeStarted {
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]
        if let factsCellViewModel = rowViewModel as? FactsCellViewModel {
          DebugLog.print("Visible row download")
          getImageFor(factsCellViewModel: factsCellViewModel, at: indexPath)
        }
      }
    }
  }
}
