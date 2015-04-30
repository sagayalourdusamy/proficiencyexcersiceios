//
//  FactsBuilder.m
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FactsCommonConstants.h"
#import "FactsBuilder.h"
#import "Facts.h"

@implementation FactsBuilder
+ (NSMutableArray *)factsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSMutableArray *factsArray = nil;
    NSError *localError = nil;
    NSString *string = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    
    NSData *myData = nil;
    NSDictionary *parsedObject = nil;
    
    if(string) {
        myData = [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if(myData) {
        parsedObject = [NSJSONSerialization JSONObjectWithData:myData options:0 error:&localError];
    }
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    if(parsedObject) {
        factsArray = [[NSMutableArray alloc] init];
        NSString *groupTitle = [parsedObject valueForKey:kJSonTitleKey];
        
        NSArray *results = [parsedObject valueForKey:kJSonRowsKey];
        NSLog(@"Count %lu", (unsigned long)results.count);
        
        //iterate through all the rows in JSON and add the valid record into the factsArray
        for (NSDictionary *factDic in results) {
            Facts *facts  = [[Facts alloc] init];
            
            for (NSString *key in factDic) {
                NSString *factCustomKey = [NSString stringWithFormat:kCustomFactPrefixforKey, key];
                
                if ([facts respondsToSelector:NSSelectorFromString(factCustomKey)]) {
                    [facts setValue:[factDic valueForKey:key] forKey:factCustomKey];
                }
            }
            
            if ([facts respondsToSelector:NSSelectorFromString(kGroupTitle)]) {
                [facts setValue:groupTitle forKey:kGroupTitle];
            }
            
            if( (facts.factdescription == nil || [facts.factdescription isEqual:[NSNull null]]) &&
               (facts.facttitle == nil || [facts.facttitle isEqual:[NSNull null]]) &&
               (facts.factimageHref == nil || [facts.factimageHref isEqual:[NSNull null]]) ) {
                //Skip the invalid record
            }
            else {
                //Add the valid record
                [factsArray addObject:facts];
            }
        }
    }
    
    return factsArray;
}
@end
