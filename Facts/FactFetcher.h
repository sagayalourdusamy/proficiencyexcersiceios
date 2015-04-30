//
//  FactFetcher.h
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Facts_FactFetcher_h
#define Facts_FactFetcher_h

@protocol FactFetcherDelegate;

@interface FactFetcher : NSObject
@property (weak, nonatomic) id<FactFetcherDelegate> delegate;

- (void)fetchFacts:(NSString *)urlAsString;
@end

#endif
