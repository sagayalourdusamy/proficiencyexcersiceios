//
//  FactsCell.m
//  Facts
//
//  Created by Cognizant on 4/25/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FactsCell.h"
#import "FactsLabel.h"

@interface FactsCell()

@property (nonatomic,strong) NSMutableArray *rightGutterConstraints;

@end


@implementation FactsCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    //set the accessoryType to None
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.backgroundColor = [UIColor colorWithRed:213/255.f green:213/255.f blue:213/255.f alpha:1.f];
    
    //Creates fact title
    self.factTitle = [[FactsLabel alloc] init];
    self.factTitle.font = [UIFont boldSystemFontOfSize:20.f];
    self.factTitle.textColor = [UIColor colorWithRed:63/255.f green:37/255.f blue:188/255.f alpha:1.f];
    [self.contentView addSubview:self.factTitle];
    
     //Creates fact description
    self.factDescription = [[FactsLabel alloc] init];
    self.factDescription.font = [UIFont systemFontOfSize:15.f];
    self.factDescription.numberOfLines = 0;
    [self.contentView addSubview:self.factDescription];
    
    //Creates fact image view
    self.factImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.factImageView];
    
    //Do not translate auto resizing mask in to constraints
    self.factTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.factDescription.translatesAutoresizingMaskIntoConstraints = NO;
    self.factImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Create constraints array for right Gutter
    self.rightGutterConstraints = [NSMutableArray array];
    
    [self applyConstraints];
    
    return self;
}


#pragma mark - State

- (void)setFacts:(Facts *)facts {
    _facts = facts;

    if(![self.facts.facttitle isEqual:[NSNull null]]){
        self.factTitle.text = self.facts.facttitle;
    }
    else {
        self.factTitle.text = nil;
    }
    
    if(![self.facts.factdescription isEqual:[NSNull null]]){
        self.factDescription.text = self.facts.factdescription;
    }
    else {
        self.factDescription.text = nil;
    }
    
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Layout


- (void)applyConstraints {
    

    [self.contentView removeConstraints:self.contentView.constraints];

    const double cellPadding = 10.f;
    
    // add factTitle constraints
    //add  factTitle left margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.factTitle
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:cellPadding]];
    
     //add factTitle top margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.factTitle
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:cellPadding]];
    //add factTitle bottom margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.factTitle
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.factDescription
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0]];

    // add factDescription constraints
    // add factDescription left margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.factDescription
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:cellPadding]];
    
    // add factDescription right margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.factDescription
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.factImageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:0]];
    
    // add factImageView constraints
    // add factImageView top margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.factImageView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.factDescription
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1
                                                                       constant:0]];
    
    // add factImageView constant width constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.factImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:70]];
    
    // add factImageView constant height constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.factImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:60]];
    
    // add right gutter right attribute constraints
    [self.rightGutterConstraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.factImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1
                                                                         constant:cellPadding]];
    
    // add factDescription bottom margin constraints and flexible height
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.factDescription
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                    toItem:self.factImageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:0]];

    // add right gutter bottom and flexebile height constraints
    [self.rightGutterConstraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.factDescription
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:cellPadding]];

    
    [self.contentView addConstraints:self.rightGutterConstraints];
    
 
}

+ (CAGradientLayer*)grayGradient {
    
    //Creates and returns gradient layer
    
    UIColor *colorOne = [UIColor colorWithRed:(239/255.0) green:(239/255.0) blue:(239/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(208/255.0)  green:(208/255.0)  blue:(208/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}
@end