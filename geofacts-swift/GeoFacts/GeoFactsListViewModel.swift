///
///  GeoFactsListViewModel.swift
///  GeoFacts
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 11/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import Foundation

//
// To get the facts list changes, used observer design pattern
//
class GeoFactsListViewModelObservables {
  //Observable  model objects for the Facts list changes
  let title = Observable<String>(value: Constants.loadingText)
  let isLoading = Observable<Bool>(value: false)
  let isRefreshing = Observable<Bool>(value: false)
  let isServiceFailed = Observable<Bool>(value: false)
  let isTableViewHidden = Observable<Bool>(value: false)
  let sectionViewModels = Observable<SectionViewModel>(value: SectionViewModel(rowViewModels: []))
  var serviceError: NSError?
}

//
// Fact table list controller, initialized with dependent service and modeel oobject.
// Fetches the service response and populate view
//
class GeoFactsListViewModel {
  let geoFactsService: GeoFactsServiceProtocol
  let observables: GeoFactsListViewModelObservables
  
  init(observables: GeoFactsListViewModelObservables = GeoFactsListViewModelObservables(),
       geoFactsService: GeoFactsServiceProtocol = GeoFactsService()) {
    self.observables = observables
    self.geoFactsService = geoFactsService
  }
  
  func start() {
    self.observables.isLoading.value = true
    self.observables.isServiceFailed.value = false
    self.observables.isTableViewHidden.value = true
    self.observables.title.value = Constants.loadingText
    geoFactsService.getFactsJsonData(urlEndPoint: ConfigurationManager.shared.environment.urlEndPoint,
                                     completion: { [weak self] (factsData, error) in
                                      self?.observables.isLoading.value = false
                                      self?.observables.isTableViewHidden.value = false
                                      
                                      if error != nil {
                                        self?.observables.isServiceFailed.value = true
                                        self?.observables.title.value = ""
                                        self?.observables.serviceError = error
                                        return
                                      }
                                      
                                      guard let factsData = factsData else {
                                        self?.observables.title.value = ""
                                        return
                                      }
                                      if let title = factsData.title,
                                        let rowCount = factsData.rows?.count {
                                        self?.observables.title.value = title
                                        if rowCount > 0 {
                                          self?.buildViewModels(factsData: factsData)
                                        }
                                      }
                                      
    })
  }
  
  func refreshJsonData() {
    self.observables.isRefreshing.value = true
    self.observables.isServiceFailed.value = false
    geoFactsService.getFactsJsonData(urlEndPoint: ConfigurationManager.shared.environment.urlEndPoint,
                                     completion: { [weak self] (factsData, error) in
                                      self?.observables.isRefreshing.value = false
                                      if error != nil {
                                        self?.observables.isServiceFailed.value = true
                                        return
                                      }
                                      
                                      guard let factsData = factsData else {
                                        self?.observables.isServiceFailed.value = true
                                        return
                                      }
                                      if let title = factsData.title,
                                        let rowCount = factsData.rows?.count {
                                        self?.observables.title.value = title
                                        if rowCount > 0 {
                                          self?.buildViewModels(factsData: factsData)
                                        }
                                      }
                                      
    })
  }
  
  // MARK: - Data source
  
  /// Arrange the sections/row view model and caregorize by date
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
      let factCellviewModel = FactsCellViewModel(title: title, desc: desc, imageUrl: imageUrl)
      sectionTable.append(factCellviewModel)
    }
    
    return sectionTable
  }
  
  /// Convert the row viewmodels into viewmodels
  private func converToSectionViewModel(_ sectionTable: [RowViewModel]) -> SectionViewModel {
    return SectionViewModel(rowViewModels: sectionTable)
  }
}
