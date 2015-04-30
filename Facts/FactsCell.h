//
//  FactsCell.h
//  Facts
//
//  Created by Cognizant on 4/25/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facts.h"

#ifndef Facts_FactCell_h
#define Facts_FactCell_h

@interface FactsCell : UITableViewCell

@property (nonatomic, strong) Facts *facts;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic,strong) UIImageView *factImageView;
@property(nonatomic,strong) UILabel *factTitle;
@property(nonatomic,strong) UILabel *factDescription;

+ (CAGradientLayer*)grayGradient;

@end

#endif
