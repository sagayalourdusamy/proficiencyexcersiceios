//
//  FactFetcher.m
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactFetcher.h"
#import "FactFectherDelegate.h"

@implementation FactFetcher

- (void)fetchFacts:(NSString *)urlAsString;
{
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //fetching fact fact failed, log it or handle it
            [self.delegate fetchingFactsFailedWithError:error];
        } else {
            //parse the fetched facts and add it into fact array
            [self.delegate receivedFactsJSON:data];
        }
    }];
}

@end