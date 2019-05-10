//
//  ListViewController.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 30/04/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import UIKit

//
// ListViewController to display the content (including image, title and description) in a table
//
class ListViewController: UIViewController, ListImageDownloaderDelegate {

  lazy var viewModel: ListViewModel = {
    return ListViewModel()
  }()

  var observables: ListViewModelObservables {
    return viewModel.observables
  }

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self.viewModel
    tableView.dataSource = self.viewModel
    //Dynamically calculate size
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.estimatedRowHeight = Constants.estimatedRowHeight
    tableView.rowHeight = UITableView.automaticDimension

    view.addSubview(tableView)

    //autolayout the table view - pin 0 up 0 left 0 right 0 down
    let viewsDictionary = ["stackView": tableView]
    let tableViewH = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[stackView]-0-|",  //horizontal constraint 0 points from left and right side
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: viewsDictionary)
    let tableViewV = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[stackView]-0-|", //vertical constraint 0 points from top and bottom
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: viewsDictionary)
    view.addConstraints(tableViewH)
    view.addConstraints(tableViewV)

    tableView.register(FactCell.self, forCellReuseIdentifier: FactCell.cellIdentifier())
    return tableView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    //Dynamically calculate size
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor.black
    label.font = UIFont.boldSystemFont(ofSize: StyleManager.getTitleFont())
    NSLayoutConstraint.activate([label.heightAnchor.constraint(equalToConstant: Constants.titleHeight)])
    return label
  }()

  private var refreshControll = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()

    initView()
    initRefreshController()
    initBinding()
    viewModel.start()
  }

  // MARK: - initialize methods

  func initView() {
    view.backgroundColor = .white
    viewModel.delegate = self
    tableView.tableFooterView = UIView()
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

    observables.isServiceFailed.addObserver { [weak self] (isServiceFailed) in
      if isServiceFailed {
        self?.showServiceFailedAlert()
      }
    }

    observables.isRefreshing.addObserver { [weak self] (isRefreshing) in
      if !isRefreshing {
        self?.refreshControll.endRefreshing()
      }
    }

    observables.isLoading.addObserver { [weak self] (isLoading) in
      if isLoading {
        self?.showIndicator(withTitle: Constants.loadingText, description: Constants.loadingDescription)
      } else {
        self?.hideIndicator()
      }
    }
  }

  func initRefreshController() {
    refreshControll.tintColor = .green
    refreshControll.attributedTitle = NSAttributedString(string: Constants.refreshText)
    refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    tableView.addSubview(self.refreshControll)
  }

  deinit {
    observables.sectionViewModels.removeObserver()
    observables.title.removeObserver()
    observables.isTableViewHidden.removeObserver()
    observables.isServiceFailed.removeObserver()
  }

  // MARK: - Image download delegate method

  func reloadTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
    DispatchQueue.main.async {
      self.tableView.reloadRows(at: indexPaths, with: .none)
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
    case Constants.Status.invalidRequest:
      title = Constants.ErrorDomain.invalidRequest
      message = Constants.ErrorMessage.invalidRequest
    case Constants.Status.invalidResponse:
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
