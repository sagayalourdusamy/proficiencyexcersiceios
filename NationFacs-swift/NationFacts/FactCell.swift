//
//  FactCell.swift
//  NationFacts
//
//  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 01/05/19.
//  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
//

import UIKit

protocol CellImageDownloaderDelegate: class {
  func getImageFor(factCellViewModel: FactCellViewModel, at indexPath: IndexPath)
}

class FactCell: UITableViewCell {
  //Facts title text
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    //Dynamically calculate size
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)

    label.textColor = UIColor.black
    label.font = UIFont.systemFont(ofSize: StyleManager.getMediumFont())
    return label
  }()

  //Facts description text
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    //Dynamically calculate size
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)

    label.textColor = UIColor.darkGray
    label.font = UIFont.systemFont(ofSize: StyleManager.getSmallFont())
    label.numberOfLines = Constants.defaultLines
    return label
  }()

  //Facts image
  lazy var factImageView: UIImageView = {
    let imageView = UIImageView()
    //Dynamically calculate size
    imageView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(imageView)

    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = Constants.imageRadius
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  var viewModel: FactCellViewModel?
  weak var delegate: CellImageDownloaderDelegate?

  // MARK: - Initialize - methods

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupInitialView()
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupInitialView()
    setupConstraints()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
  }

  // MARK: - Setup methods

  func setup(viewModel: RowViewModel, at indexPath: IndexPath, forScrollingState isNotScrolling: Bool) {
    guard let viewModel = viewModel as? FactCellViewModel else { return }
    self.viewModel = viewModel
    titleLabel.text = viewModel.title
    descriptionLabel.text = viewModel.desc
    factImageView.image = viewModel.image

    if accessoryView == nil {
      let indicator = UIActivityIndicatorView(style: .gray)
      accessoryView = indicator
    }
    var indicator: UIActivityIndicatorView?
    indicator = accessoryView as? UIActivityIndicatorView

    switch viewModel.imageState {
    case .downloaded, .failed:
      indicator?.stopAnimating()
    case .new:
      indicator?.startAnimating()
      if isNotScrolling {
        delegate?.getImageFor(factCellViewModel: viewModel, at: indexPath)
      }
    }

    setNeedsLayout()
  }

  private func setupInitialView() {
    self.selectionStyle = .none
  }

  // MARK: - Setup Constraints

  private func setupConstraints() {

    let stackView = UIStackView(arrangedSubviews: [factImageView, titleLabel, descriptionLabel])
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = Constants.cellPadding
    stackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stackView)

    //autolayout the stack view - pin  up left  right  down
    let viewsDictionary = ["stackView": stackView]
    let stackViewH = NSLayoutConstraint.constraints(
       //horizontal constraint for left and right side
      withVisualFormat: "H:|-\(Constants.cellPadding)-[stackView]-\(Constants.cellPadding)-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: viewsDictionary)
    let stackViewV = NSLayoutConstraint.constraints(
      //vertical constraint for top and bottom
      withVisualFormat: "V:|-\(Constants.cellPadding)-[stackView]-\(Constants.cellPadding)-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: viewsDictionary)
    contentView.addConstraints(stackViewH)
    contentView.addConstraints(stackViewV)

    //Flexible height for description lablel
    factImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
}
