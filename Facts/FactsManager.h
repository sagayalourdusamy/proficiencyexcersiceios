//
//  FactsManager.h
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "FactsManagerDelegate.h"
#import "FactFectherDelegate.h"

#ifndef Facts_FactsManager_h
#define Facts_FactsManager_h

@class FactFetcher;

@interface FactsManager : NSObject<FactFetcherDelegate>
@property (strong, nonatomic) FactFetcher *factFetcher;
@property (weak, nonatomic) id<FactsManagerDelegate> delegate;

- (void)fetchFactsFrom:(NSString *)urlAsString;
@end

#endif
