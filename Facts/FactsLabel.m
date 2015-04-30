//
//  FactsLabel.m
//  Facts
//
//  Created by Cognizant on 4/29/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactsLabel.h"

@implementation FactsLabel

- (id)init {
    self = [super init];
    
    // required to prevent Auto Layout from compressing the label (by 1 point usually) for certain constraint solutions
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired
                                          forAxis:UILayoutConstraintAxisVertical];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    
    [super layoutSubviews];
}

@end