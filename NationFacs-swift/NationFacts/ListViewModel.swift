//
//  ListViewModel.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 01/05/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import UIKit

//
// To get the facts list changes, used observer design pattern
//
class ListViewModelObservables {
  //Observable  model objects for the Facts list changes
  let title = Observable<String>(value: Constants.loadingText)
  let isRefreshing = Observable<Bool>(value: false)
  let isLoading = Observable<Bool>(value: false)
  let isServiceFailed = Observable<Bool>(value: false)
  let isTableViewHidden = Observable<Bool>(value: false)
  let sectionViewModels = Observable<SectionViewModel>(value: SectionViewModel(rowViewModels: []))
  var serviceError: NSError?
}

protocol ListImageDownloaderDelegate: class {
  func reloadTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}

class ListViewModel: NSObject, CellImageDownloaderDelegate {
  let factsQueryService: FactsQueryProrocol
  let observables: ListViewModelObservables
  weak var delegate: ListImageDownloaderDelegate?
  private var cellHeights: [IndexPath: CGFloat?] = [:]

  init(observables: ListViewModelObservables = ListViewModelObservables(),
       geoFactsService: FactsQueryProrocol = FactsQueryService()) {
    self.observables = observables
    self.factsQueryService = geoFactsService
  }

  func start() {
    self.observables.isLoading.value = true
    observables.isServiceFailed.value = false
    observables.isTableViewHidden.value = true
    observables.title.value = Constants.loadingText
    factsQueryService.getFactsList(from: ConfigurationManager.shared.environment.urlEndPoint,
                                   success: { [weak self] (factsData) in
                                    self?.observables.isTableViewHidden.value = false
                                    self?.observables.isLoading.value = false

                                    guard let factsData = factsData else {
                                      self?.observables.title.value = ""
                                      return
                                    }
                                    self?.extractModelDataFrom(factsData: factsData)
      },
                                   failure: { [weak self] (error) in
                                    self?.observables.isLoading.value = false
                                    if error != nil {
                                      self?.observables.isServiceFailed.value = true
                                      self?.observables.title.value = ""
                                      self?.observables.serviceError = error
                                      return
                                    }
    })
  }

  func refreshJsonData() {
    self.observables.isRefreshing.value = true
    self.observables.isServiceFailed.value = false
    factsQueryService.getFactsList(from: ConfigurationManager.shared.environment.urlEndPoint,
                                   success: { [weak self] (factsData) in
                                    self?.observables.isRefreshing.value = false

                                    guard let factsData = factsData else {
                                      return
                                    }
                                    self?.extractModelDataFrom(factsData: factsData)
      },
                                   failure: { [weak self] (error) in
                                    self?.observables.isRefreshing.value = false
                                    if error != nil {
                                      self?.observables.isServiceFailed.value = true
                                      self?.observables.serviceError = error
                                      return
                                    }
    })
  }

  // MARK: - Data source

  // Validate fact data
  func extractModelDataFrom(factsData: FactsData) {
    if let title = factsData.title,
      let rowCount = factsData.rows?.count {
      self.observables.title.value = title
      if rowCount > 0 {
        self.buildViewModels(factsData: factsData)
      }
    }
  }

  // Arrange the sections/row view model and caregorize by date
  func buildViewModels(factsData: FactsData) {
    var sectionTable = [RowViewModel]()

    if let factsList = factsData.rows {
      sectionTable = getFactsCellViewModel(factsList: factsList)
      self.observables.sectionViewModels.value = converToSectionViewModel(sectionTable)
    }
  }

  //get fact cell view model for talble view rows
  func getFactsCellViewModel(factsList: [FactsRecord]) -> [RowViewModel] {
    var sectionTable = [RowViewModel]()

    for fact in factsList {
      let title = fact.title ?? ""
      let desc = fact.description ?? ""
      var imageUrl: URL?
      if let imageHref = fact.imageHref {
        imageUrl = URL(string: imageHref)
      }
      let factCellviewModel = FactCellViewModel(title: title, desc: desc, imageUrl: imageUrl)
      sectionTable.append(factCellviewModel)
    }

    return sectionTable
  }

  // Convert the row viewmodels into section viewmodels
  private func converToSectionViewModel(_ sectionTable: [RowViewModel]) -> SectionViewModel {
    return SectionViewModel(rowViewModels: sectionTable)
  }

  // MARK: List Image downloader delegate method
  func getImageFor(factCellViewModel: FactCellViewModel, at indexPath: IndexPath) {
    ImageDownloadHelper.shared.getImage(factCellViewModel: factCellViewModel) { (image) in
      if image != nil {
        DispatchQueue.main.async {
          DebugLog.print("Reload the table view")
          self.delegate?.reloadTableViewRows(at: [indexPath], with: .none)
        }
      } else {
        self.downloadImageFor(factCellViewModel: factCellViewModel, at: indexPath)
      }
    }
  }

  // MARK: Image laod/download methods
  func downloadImageFor(factCellViewModel: FactCellViewModel, at indexPath: IndexPath) {
    ImageDownloadHelper.shared.startDownload(factCellViewModel: factCellViewModel, at: indexPath) {
      if ImageDownloadHelper.shared.downloader.isCancelled {
        return
      }
      DispatchQueue.main.async {
        let pendingOperations = ImageDownloadHelper.shared.pendingOperations
        pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        self.delegate?.reloadTableViewRows(at: [indexPath], with: .none)
      }
    }
  }

  func loadImagesForVisibleCells(for tableView: UITableView) {
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
        if let factCellViewModel = rowViewModel as? FactCellViewModel {
          DebugLog.print("Visible row download")
          getImageFor(factCellViewModel: factCellViewModel, at: indexPath)
        }
      }
    }
  }
}

extension ListViewModel: UITableViewDelegate {
  // MARK: - scrollvoew delegate methods
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    ImageDownloadHelper.shared.suspendAllOperations()
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate,
      let tableView = scrollView as? UITableView {
      loadImagesForVisibleCells(for: tableView)
      ImageDownloadHelper.shared.resumeAllOperations()
    }
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if let tableView = scrollView as? UITableView {
      loadImagesForVisibleCells(for: tableView)
      ImageDownloadHelper.shared.resumeAllOperations()
    }
  }
}

extension ListViewModel: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionViewModel = observables.sectionViewModels.value
    return sectionViewModel.rowViewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let sectionViewModel = observables.sectionViewModels.value
    let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: FactCell.cellIdentifier(), for: indexPath)
    if let cell = cell as? FactCell {
      cell.delegate = self
      let isNotScrolling = !tableView.isDragging && !tableView.isDecelerating
      cell.setup(viewModel: rowViewModel, at: indexPath, forScrollingState: isNotScrolling)
    }
    cell.layoutIfNeeded()
    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cellHeights[indexPath] = cell.frame.height
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if let height = cellHeights[indexPath] {
      return height ?? UITableView.automaticDimension
    }
    return UITableView.automaticDimension
  }
}
