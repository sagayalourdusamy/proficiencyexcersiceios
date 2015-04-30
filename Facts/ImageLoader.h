//
//  ImageLoader.h
//  Facts
//
//  Created by Cognizant on 4/25/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facts.h"

#ifndef Facts_ImageLoader_h
#define Facts_ImageLoader_h

@protocol ImageLoaderDelegate;


@interface ImageLoader : NSOperation


@property (nonatomic, assign) id <ImageLoaderDelegate> delegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) Facts *factsRecord;

- (id)initWithFactsRecord:(Facts *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageLoaderDelegate>) theDelegate;

@end

@protocol ImageLoaderDelegate <NSObject>

//pass the whole class as an object back to the caller
- (void)imageDownloaderDidFinish:(ImageLoader *)downloader;

@end

#endif
