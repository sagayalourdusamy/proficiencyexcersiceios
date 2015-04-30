//
//  FactsBuilder.h
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Facts_FactsBuilder_h
#define Facts_FactsBuilder_h

@interface FactsBuilder : NSObject
+ (NSMutableArray *)factsFromJSON:(NSData *)objectNotation error:(NSError **)error;
@end

#endif
