//
//  FactsManagerDelegate.h
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Facts_FactsManagerDelegate_h
#define Facts_FactsManagerDelegate_h

@protocol FactsManagerDelegate
//handler for latest received facts
- (void)didReceiveFacts:(NSArray *)groups;
//error handler
- (void)fetchingFactsFailedWithError:(NSError *)error;
@end

#endif
