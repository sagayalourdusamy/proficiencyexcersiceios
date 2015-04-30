//
//  FactFectherDelegate.h
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Facts_FactFectherDelegate_h
#define Facts_FactFectherDelegate_h

@protocol FactFetcherDelegate
- (void)receivedFactsJSON:(NSData *)objectNotation;
- (void)fetchingFactsFailedWithError:(NSError *)error;
@end

#endif
