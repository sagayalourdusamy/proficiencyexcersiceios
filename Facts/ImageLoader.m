//
//  ImageLoader.m
//  Facts
//
//  Created by Cognizant on 4/25/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoader.h"

@interface ImageLoader ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) Facts *factsRecord;

@end

@implementation ImageLoader

- (id)initWithFactsRecord:(Facts *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageLoaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        //Set the properties.
        self.delegate = theDelegate;
        self.indexPathInTableView = indexPath;
        self.factsRecord = record;
    }
    return self;
}

- (void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
 
        NSURL *imageURL = nil;
        if(![self.factsRecord.factimageHref isEqual:[NSNull null]]){
             imageURL = [NSURL URLWithString:self.factsRecord.factimageHref];
        }
        
        // Load the image from the url
        NSData *imageData = nil;
        if(imageURL != nil) {
            imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
        }
        
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        if (imageData) {
            UIImage *downloadedImage = [UIImage imageWithData:imageData];
            self.factsRecord.image = downloadedImage;
        }
        else {
            self.factsRecord.failed = YES;
        }
        
        imageData = nil;
        
        if (self.isCancelled)
            return;
        
        // Display the image in UI main thread
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}

@end