//
//  Facts.h
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef Facts_Facts_h
#define Facts_Facts_h

@interface Facts : NSObject
@property (strong, nonatomic) NSString *factgrouptitle;
@property (strong, nonatomic) NSString *facttitle;
@property (strong, nonatomic) NSString *factdescription;
@property (strong, nonatomic) NSString *factimageHref;
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, getter = isFailed) BOOL failed;
@property (nonatomic, readonly) BOOL hasImage;
@end

#endif
