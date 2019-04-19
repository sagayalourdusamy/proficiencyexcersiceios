///
///  GeoFactsListViewController.swift
///  GeoFacts
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 10/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import UIKit

//
// Facts list viewcontroller, initialize tabeview and refresh controller and activity indicator.
//
class GeoFactsListViewController: UIViewController {
  
  private var refreshControll = UIRefreshControl()
  
  var observables: GeoFactsListViewModelObservables {
    return viewModel.observables
  }
  
  lazy var viewModel: GeoFactsListViewModel = {
    return GeoFactsListViewModel()
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    //Dynamically calculate size
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.estimatedRowHeight = Constants.estimatedRowHeight
    tableView.rowHeight = UITableView.automaticDimension
    
    view.addSubview(tableView)
    NSLayoutConstraint.activate(tableView.edgeConstraints(top: Constants.cellPadding,
                                                          left: 0, bottom: 0, right: 0))
    
    tableView.register(FactsCell.self, forCellReuseIdentifier: FactsCell.cellIdentifier())
    return tableView
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    //Dynamically calculate size
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor.black
    label.font = UIFont.boldSystemFont(ofSize: Constants.getTitleFont())
    NSLayoutConstraint.activate([label.heightAnchor.constraint(equalToConstant: Constants.titleHeight)])
    return label
  }()
  
  lazy var loadingIdicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .gray)
    //Dynamically calculate size
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.hidesWhenStopped = true
    self.view.addSubview(indicator)
    NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
      ])
    return indicator
  }()
  
  // MARK: - view life cycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initView()
    initRefreshController()
    initBinding()
    viewModel.start()
  }
  
  deinit {
    observables.sectionViewModels.removeObserver()
    observables.title.removeObserver()
    observables.isTableViewHidden.removeObserver()
    observables.isLoading.removeObserver()
    observables.isRefreshing.removeObserver()
    observables.isServiceFailed.removeObserver()
  }
  
  // MARK: - initialize methods
  
  func initView() {
    view.backgroundColor = .white
  }
  
  func initRefreshController() {
    refreshControll.tintColor = .green
    refreshControll.attributedTitle = NSAttributedString(string: Constants.refreshText)
    refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    tableView.addSubview(self.refreshControll)
  }
  
  //bind view model with observers to react on changes made by controller
  func initBinding() {
    
    observables.sectionViewModels.addObserver(fireNow: false) { [weak self] (_) in
      self?.tableView.reloadData()
    }
    
    observables.title.addObserver { [weak self] (title) in
      self?.titleLabel.text = title
      self?.navigationItem.titleView = self?.titleLabel
    }
    
    observables.isTableViewHidden.addObserver { [weak self] (isHidden) in
      self?.tableView.isHidden = isHidden
    }
    
    observables.isLoading.addObserver { [weak self] (isLoading) in
      if isLoading {
        self?.loadingIdicator.startAnimating()
      } else {
        self?.loadingIdicator.stopAnimating()
      }
    }
    
    observables.isRefreshing.addObserver { [weak self] (isRefreshing) in
      if !isRefreshing {
        self?.refreshControll.endRefreshing()
      }
    }
    
    observables.isServiceFailed.addObserver { [weak self] (isServiceFailed) in
      if isServiceFailed {
        self?.showServiceFailedAlert()
      }
    }
  }
  
  // MARK: - refresh methods
  
  @objc
  func refresh() {
    viewModel.refreshJsonData()
  }
  
  func endRefresh() {
    DispatchQueue.main.async {
      self.refreshControll.endRefreshing()
    }
  }
  
  // MARK: - Service failure alert
  
  //Service failure alert
  func showServiceFailedAlert() {
    
    let error = self.observables.serviceError
    
    var title = ""
    var message = ""
    
    switch error?.code {
    case Constants.ErrorCode.invalidRequest:
      title = Constants.ErrorDomain.invalidRequest
      message = Constants.ErrorMessage.invalidRequest
    case Constants.ErrorCode.invalideResponse:
      title = Constants.ErrorDomain.invalidData
      message = Constants.ErrorMessage.invalidData
    default:
      title = Constants.ErrorDomain.serviceError
      message = Constants.ErrorMessage.serviceError
    }
    
    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
    let okAction = UIAlertAction(title: Constants.okAlertText, style: .default)
    alertController.addAction(okAction)
    DispatchQueue.main.async {
      self.present(alertController, animated: true, completion: nil)
    }
  }
}

//
// Data source protocol comformance extention
//
extension GeoFactsListViewController: UITableViewDataSource {
  
}

//
// Delegate source protocol comformance extention
//
extension GeoFactsListViewController: UITableViewDelegate {
  
}
