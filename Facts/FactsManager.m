//
//  FactsManager.m
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FactsManager.h"
#import "FactsBuilder.h"
#import "FactFetcher.h"

@implementation FactsManager
- (void)fetchFactsFrom:(NSString *)urlAsString
{
    [self.factFetcher fetchFacts:urlAsString];
}

#pragma mark - FactFetcherDelegate

- (void)receivedFactsJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    NSArray *facts = [FactsBuilder factsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        //fetching fact fact failed, log it or handle it
        [self.delegate fetchingFactsFailedWithError:error];
        
    } else {
        //Update the facts in UI main thread
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(didReceiveFacts:) withObject:facts waitUntilDone:NO];
    }
}

- (void)fetchingFactsFailedWithError:(NSError *)error
{
    [self.delegate fetchingFactsFailedWithError:error];
}
@end
