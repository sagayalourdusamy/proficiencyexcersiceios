///
///  FactsCell.swift
///  GeoFacts
///
///  Created by Lourdusamy, Sagaya Martin Luther King (Cognizant) on 11/04/19.
///  Copyright © 2019 Lourdusamy, Sagaya Martin Luther King (Cognizant). All rights reserved.
///

import UIKit

class FactsCell: UITableViewCell {
  //Facts title text
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    //Dynamically calculate size
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    
    label.textColor = UIColor.black
    label.font = UIFont.systemFont(ofSize: Constants.getMediumFont())
    return label
  }()
  
  //Facts description text
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    //Dynamically calculate size
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    
    label.textColor = UIColor.darkGray
    label.font = UIFont.systemFont(ofSize: Constants.getSmallFont())
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
  
  var viewModel: FactsCellViewModel?
  
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
  
  func setup(viewModel: RowViewModel) {
    guard let viewModel = viewModel as? FactsCellViewModel else { return }
    self.viewModel = viewModel
    self.titleLabel.text = viewModel.title
    self.descriptionLabel.text = viewModel.desc
    self.factImageView.image = viewModel.image
    
    setNeedsLayout()
  }
  
  private func setupInitialView() {
    self.selectionStyle = .none
  }
  
  // MARK: - Setup Constraints
  
  private func setupConstraints() {
    
    NSLayoutConstraint.activate([
      //set up imageview left, top and bottom constraint
      factImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellPadding),
      factImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.cellPadding),
      factImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                           constant: -(Constants.cellPadding)),
      
      //set up title lable top, left and right constraint
      titleLabel.topAnchor.constraint(equalTo: factImageView.bottomAnchor, constant: Constants.cellPadding),
      titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.cellPadding),
      titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                        constant: -(Constants.cellPadding)),
      
      //set up description label top, left, right and bottom constraint
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                            constant: Constants.cellPadding),
      descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.cellPadding),
      descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                              constant: -(Constants.cellPadding)),
      descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                               constant: -(Constants.cellPadding))
      
      ])
    
    titleLabel.accessibilityIdentifier = Constants.titleLabelIdentifier
    factImageView.accessibilityIdentifier = Constants.factImageIdentifier
    descriptionLabel.accessibilityIdentifier = Constants.descriptionLabelIdentifier
    contentView.accessibilityIdentifier = Constants.contentViewIdentifier
    
    //Flexible height for description lablel
    descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    
  }
  
}
