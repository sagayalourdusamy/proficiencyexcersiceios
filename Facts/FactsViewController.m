//
//  FactsViewController.m
//  Facts
//
//  Created by Cognizant on 4/24/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "FactsViewController.h"
#import "FactFetcher.h"
#import "FactsManager.h"
#import "Facts.h"
#import "FactsCell.h"
#import "OperationsList.h"
#import "ImageLoader.h"
#import "FactsCommonConstants.h"

@interface FactsViewController () <FactsManagerDelegate>

@property (nonatomic, strong) NSMutableDictionary *offscreenCells;
@property (nonatomic, strong) FactsManager *factsManager;
@property (nonatomic, strong) NSMutableArray *factsList;
@property (nonatomic, strong) OperationsList *pendingOperations;

@end


@implementation FactsViewController


-(void)loadView {
    [super loadView];
    //Initialize the facts manager
    _factsManager = [[FactsManager alloc] init];
    _factsManager.factFetcher = [[FactFetcher alloc] init];
    _factsManager.factFetcher.delegate = _factsManager;
    _factsManager.delegate = self;
    
    //Do the initial fact fetch
    [self.factsManager fetchFactsFrom:kFactsJsonURL];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blueColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    
    //add target action for refres control
    [self.refreshControl addTarget:self
                            action:@selector(refreshFacts)
                  forControlEvents:UIControlEventValueChanged];
}

-(void) refreshFacts {
    //fetch the latest facts from back end and update the UI
   [self.factsManager fetchFactsFrom:kFactsJsonURL];
}
#pragma mark - FactFetcherDelegate
- (void)didReceiveFacts:(NSMutableArray *)facts
{
    //recieves the latest fatcts
    _factsList = facts;
    
    //Update the table view title with fact group title
    Facts *fact = (Facts *)[_factsList objectAtIndex:0];
    self.title = fact.factgrouptitle;
    
    //Reload the table with latest data
    [self.tableView reloadData];
    
    //Stop the refressControl on receving the latest data
    [self.refreshControl endRefreshing];
}

- (void)fetchingFactsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //set the tableview row as the number of fact
    return self.factsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the OffScreenCell height with newly calculated height to make felixble cell height
    
    NSString *reuseIdentifier = @"OffScreenCell";
    
    FactsCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    
    if (!cell) {
        cell = [[FactsCell alloc] initWithReuseIdentifier:nil];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    
    //Get the fact for the row from the fact list
    Facts *facts = self.factsList[indexPath.row];
    cell.facts = facts;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    //get the cell bounds
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    //Calculate the new/required cell height
    CGFloat calculatedHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    calculatedHeight += 1.0f;
 
  
    return calculatedHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"Cell";
    
 
    FactsCell *cell = nil;
    
    //Get the fact for the row from the fact list
    Facts *aRecord = self.factsList[indexPath.row];
    
    //Reuse the cell if available
    cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        //Create the cell
        cell = [[FactsCell alloc] initWithReuseIdentifier:kCellIdentifier];
    }

    // set the facts
    cell.facts = aRecord;

    if (aRecord.hasImage) {
        //show the image if available
        cell.factImageView.image = aRecord.image;
    }
    else if (aRecord.isFailed) {
        //show the failed place holder for the download failed images
        cell.factImageView.image = [UIImage imageNamed:kFailedImageName];
    }
    else {
        //show the image not available place holder for no image
        cell.factImageView.image = [UIImage imageNamed:kNotAvailbleImageName];;
        
        if (!tableView.dragging && !tableView.decelerating) {
            [self startOperationsForFactRecord:aRecord atIndexPath:indexPath];
        }
    }

    //add gradient layer for cell
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    CGRect myRect = CGRectMake(0, 0, self.tableView.bounds.size.width, height);
    
    cell.frame = myRect;
    UIView *myView = [[UIView alloc] initWithFrame:myRect];
    CAGradientLayer *gradientLayer = [FactsCell grayGradient];
    
    gradientLayer.bounds = myRect;
    gradientLayer.position = cell.center;
    gradientLayer.startPoint = CGPointZero;
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    
    [myView.layer addSublayer:gradientLayer];
    cell.backgroundView = myView;

    return cell;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // resize the layers based on the view’s new bounds
    [[[self.view.layer sublayers] objectAtIndex:0] setFrame:self.view.frame];
    
    //Reload the data
    [self.tableView reloadData];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self suspendAllOperations];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenCells];
    [self resumeAllOperations];
}


#pragma mark - ImageLoaderDelegate

- (void)imageDownloaderDidFinish:(ImageLoader *)downloader {
    
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    Facts *theRecord = downloader.factsRecord;
    
    //Update the facts list and relaod table view with latest data with image
    [self.factsList replaceObjectAtIndex:indexPath.row withObject:theRecord];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}


#pragma mark - Operations

- (OperationsList *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[OperationsList alloc] init];
    }
    return _pendingOperations;
}

- (void)startOperationsForFactRecord:(Facts *)record atIndexPath:(NSIndexPath *)indexPath {
    
    if (!record.hasImage) {
        [self startImageDownloadingForRecord:record atIndexPath:indexPath];
    }
    
}

- (void)startImageDownloadingForRecord:(Facts *)record atIndexPath:(NSIndexPath *)indexPath {
    
    // check for the particular indexPath to see if there is already an operation in downloadsInProgress for it. If so, ignore it.
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        
        // create an instance of ImageDownloader by using the designated initializer, and set FactsViewController as the delegate. Pass in the appropriate indexPath and a pointer to the instance of user record, and then add it to the download queue. Also add it to downloadsInProgress to help keep track of things.
        // Start downloading
        ImageLoader *imageDownloader = [[ImageLoader alloc] initWithFactsRecord:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)suspendAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:YES];
}


- (void)resumeAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:NO];
}


- (void)cancelAllOperations {
    [self.pendingOperations.downloadQueue cancelAllOperations];
}

- (void)loadImagesForOnscreenCells {
    
    //get the visible table cell rows
    NSSet *visibleRows = [NSSet setWithArray:[self.tableView indexPathsForVisibleRows]];
    
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    
    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    
    [toBeStarted minusSet:pendingOperations];
    
    [toBeCancelled minusSet:visibleRows];
    
    for (NSIndexPath *anIndexPath in toBeCancelled) {
        
        ImageLoader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
        
    }
    toBeCancelled = nil;
    
    // Loop through to be started, and call startOperationsForUserRecord:atIndexPath: for each.
    for (NSIndexPath *anIndexPath in toBeStarted) {
        
        Facts *recordToProcess = [self.factsList objectAtIndex:anIndexPath.row];
        [self startOperationsForFactRecord:recordToProcess atIndexPath:anIndexPath];
    }
    
    toBeStarted = nil;
    
}

#pragma mark - Memoryhandling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
