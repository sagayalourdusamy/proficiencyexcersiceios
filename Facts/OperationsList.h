//
//  OperationsList.h
//  Facts
//
//  Created by Cognizant on 4/25/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Facts_OperationList_h
#define Facts_OperationList_h

@interface OperationsList : NSObject

@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end


#endif
