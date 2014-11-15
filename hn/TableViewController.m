//
//  TableViewController.m
//  hn
//
//  Created by Marcin on 08.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "TableViewController.h"
#import <Firebase/Firebase.h>
#import "SVWebViewController.h"
#import "HNTableViewCell.h"
#import "NSString+ExtractDomain.h"
#import "PrepareCommentsViewController.h"
#import "HNTableViewCell.h"
#import "PrepareProfileViewController.h"
#import "RandomColor.h"
#import "Utils.h"
#import "UIButton2Tags.h"
#import "ReachabilityManager.h"

@interface TableViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSIndexPath *selectedRow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property Firebase *storiesEvent;
@property NSMutableArray *storyEventRefs;
@property NSMutableArray* temporaryTop100StoriesIds;
@property NSMutableDictionary *temporaryStoryDescriptions;
@property __block NSNumber *numberOfFailedNewStoryDescriptions;
@property UIRefreshControl *refreshControl;
@property NSMutableDictionary *rowHeights;
@property BOOL storiesHaveBeenReloaded;

@end

@implementation TableViewController

#pragma mark - FireBase API  

- (void)getNewStoryIDs{
    
    Firebase *storiesIdEvent = [[Firebase alloc] initWithUrl:@"https://hacker-news.firebaseio.com/v0/topstories"];
    
    [storiesIdEvent observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            self.temporaryTop100StoriesIds = [snapshot.value mutableCopy];
            [self getStoryDescriptionsUsingNewIDs:YES];
       
    } withCancelBlock:^(NSError *error) {
       
    }
    ];
}



- (void)getStoryDataOfItem:(NSNumber *)itemNumber usingNewIDs:(BOOL)usingNewIDs{
 
    NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
    Firebase *storyDescriptionRef = [[Firebase alloc] initWithUrl:urlString];
    
    [self.storyEventRefs addObject:storyDescriptionRef];
    [storyDescriptionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

        NSDictionary *responseDictionary = snapshot.value;
        
        if([responseDictionary isKindOfClass:[NSDictionary class]] && [responseDictionary objectForKey:@"id"] != nil){
            if(usingNewIDs == NO){
                [self.storyDescriptions setObject:responseDictionary forKey:itemNumber];
                [self.tableView reloadData];
            }
            else{
                [self.temporaryStoryDescriptions setObject:responseDictionary forKey:itemNumber];
                
                if([self.temporaryStoryDescriptions count] == [self.temporaryTop100StoriesIds count] - [self.numberOfFailedNewStoryDescriptions integerValue]){
                    self.top100StoriesIds = self.temporaryTop100StoriesIds;
                    self.storyDescriptions = self.temporaryStoryDescriptions;
                    
                    if(self.storiesHaveBeenReloaded){
                        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastRefreshDate"];
                        self.storiesHaveBeenReloaded = NO;
                    }
                    
                    [self.tableView reloadData];
                }
            }
            
            
            
        }
        else{
            self.numberOfFailedNewStoryDescriptions = [NSNumber numberWithInteger:self.numberOfFailedNewStoryDescriptions.integerValue + 1];
            
            if(usingNewIDs == NO){
                [self.top100StoriesIds removeObject:itemNumber];
            }
            else{
                [self.temporaryTop100StoriesIds removeObject:itemNumber];
            }
        }
        
        
    } withCancelBlock:^(NSError *error) {
        
    }
     ];
}

- (void)getStoryDescriptionsUsingNewIDs:(BOOL)usingNewIDs{
    
    if(usingNewIDs){
        for(NSNumber *itemNumber in self.temporaryTop100StoriesIds){
            [self getStoryDataOfItem:itemNumber usingNewIDs:usingNewIDs];
        }
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastRefreshDate"];
        
        for(NSNumber *itemNumber in self.top100StoriesIds){
            [self getStoryDataOfItem:itemNumber usingNewIDs:usingNewIDs];
        }
    }
    
}

- (void)reloadAllData{
    
    self.storiesHaveBeenReloaded = YES;
    
     [self.refreshControl endRefreshing];
    
    if(![ReachabilityManager isReachable]){
        [self.refreshControl endRefreshing];
       NSString *message = @"The internet connection appears to be offline";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    self.temporaryStoryDescriptions = [NSMutableDictionary new];
    self.numberOfFailedNewStoryDescriptions = [NSNumber numberWithInteger:0];
    for(Firebase *ref in self.storyEventRefs){
        [ref removeAllObservers];
    }
    [self getNewStoryIDs];
}

#pragma mark - View Controller

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.selectedRow animated:YES];
    self.selectedRow = nil;
    
    // Disable swipe to go back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
          self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView selectRowAtIndexPath:self.selectedRow animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rowHeights = [NSMutableDictionary new];
    
    self.storyEventRefs = [NSMutableArray new];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(reloadAllData)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    [self getStoryDescriptionsUsingNewIDs:NO];
    
    self.storiesHaveBeenReloaded = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidReturnFromBackground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"commentsSegue"]){
        
        NSInteger item = ((UIButton2Tags *)sender).tag2;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        self.selectedRow = indexPath;
        
        NSNumber *itemNumber = [NSNumber numberWithLong:((UIButton2Tags *)sender).tag];
        NSDictionary *storyDescription = [self.storyDescriptions objectForKey:itemNumber];
        
        if([[storyDescription objectForKey:@"kids"] count] > 0){
            return YES;
        }
        return NO;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"commentsSegue"]){
        
        PrepareCommentsViewController *viewController = (PrepareCommentsViewController *)segue.destinationViewController;
        
        NSNumber *itemNumber = [NSNumber numberWithLong:((UIButton2Tags *)sender).tag];
        
        CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:((UIButton2Tags *)sender).tag2 inSection:0]];
        CGFloat tableCellHeight = rect.size.height;
        
        NSDictionary *storyDescription = [self.storyDescriptions objectForKey:itemNumber];
        
        viewController.storyTitle = [storyDescription objectForKey:@"title"];
        viewController.url = [storyDescription objectForKey:@"url"];
        viewController.commentIDs = [storyDescription objectForKey:@"kids"];
        viewController.points = [[storyDescription objectForKey:@"score"] stringValue];
        viewController.author = [storyDescription objectForKey:@"by"];
        viewController.timePosted = [storyDescription objectForKey:@"time"];
        viewController.tableCellHeight = tableCellHeight;
        
    }
    
    
}

- (void)showWebViewAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *storyDescription = [self.storyDescriptions objectForKey:[self.top100StoriesIds objectAtIndex:[indexPath item]]];
    NSString *urlString = [storyDescription objectForKey:@"url"];
    
    if([urlString isEqualToString:@""] || urlString == nil){
        
        if([[storyDescription objectForKey:@"kids"] count] > 0){
            
            UIButton2Tags *tempButton = [UIButton2Tags new];
            NSNumber *itemNumber = self.top100StoriesIds[[self.selectedRow item]] ;
            [tempButton setTag:[itemNumber longValue]];
            [tempButton setTag2:[self.selectedRow item]];
            
            [self performSegueWithIdentifier:@"commentsSegue" sender:tempButton];
        }
        
        else{
            [self.tableView deselectRowAtIndexPath:self.selectedRow animated:YES];
        }
        return;
    }
    
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:urlString];
    
    [self.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - NSNotificationCenter

- (void) applicationDidReturnFromBackground:(NSNotification *) note{
    NSDate *lastRefreshDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastRefreshDate"];
    if(lastRefreshDate != nil){
        NSTimeInterval lastRefreshInterval = [[NSDate date] timeIntervalSinceDate:lastRefreshDate];
        if(lastRefreshInterval > 3600){
            [self reloadAllData];
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.storyDescriptions count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (HNTableViewCell *)configureCell:(HNTableViewCell *)cell forIndex:(long)index{
  
    NSNumber *itemNumber = self.top100StoriesIds[index];
    
    NSDictionary *storyDescription = [self.storyDescriptions objectForKey:itemNumber];
    
    cell.titleView.text = [storyDescription objectForKey:@"title"];
    
    cell.pointsLabel.text = [NSString stringWithFormat:@"%@ points", [storyDescription objectForKey:@"score"]];
    
    NSString *author = [storyDescription objectForKey:@"by"];
    
    [cell.userNameButton setTitle:author forState:UIControlStateNormal] ;
    cell.userNameButton.tag = index;
    
    NSString *url = [storyDescription objectForKey:@"url"];
    NSString *urlDomain = [url extractDomain];
    if(urlDomain == nil && url != nil){
        cell.distanceConstraint.constant = 0.0;
    }
    else{
        cell.distanceConstraint.constant = 5.0;
    }
  
    cell.domainLabel.text = urlDomain;
    
    cell.hoursAgoLabel.text = [Utils timeAgoFromTimestamp:[storyDescription objectForKey:@"time"]];
    
    long numberOfComments = [[storyDescription objectForKey:@"kids"] count];
    NSString *buttonTitle = [NSString stringWithFormat:@"%ld", numberOfComments];
    [cell.commentsButton setTitle:buttonTitle forState: UIControlStateNormal];
    [cell.commentsButton setTag:[itemNumber longValue]];
    cell.commentsButton.tag2 = index;
   
    
    UIColor *color = [RandomColor getRandomColorForNumber:[author hash]];
    
    [cell.userNameButton setTitleColor:color forState:UIControlStateNormal];
    [cell.commentsButton setTitleColor:color forState:UIControlStateNormal];
    [cell.commentsButton.layer setBorderColor:color.CGColor];
    
    UIColor *selectedColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.5];
    
    [cell.userNameButton setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [cell.commentsButton setTitleColor:selectedColor forState:UIControlStateHighlighted];

    selectedColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.15];
    UIView *backgroundColorView = [[UIView alloc] init];
    backgroundColorView.backgroundColor = selectedColor;
    [cell setSelectedBackgroundView:backgroundColorView];

 
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNCell" forIndexPath:indexPath];
    
    cell = [self configureCell:cell forIndex:[indexPath item]];
    
    [cell setNeedsDisplay];
    [cell layoutIfNeeded];
    
    //save cell height for later use in tableView:estimatedHeightForRowAtIndexPath:indexPath
    //if only estimated cell height is returned from that method once the actual heights are known
    //than on return from segue tableview appears to have scrolled a bit
    
    //NSMutableIndexPath to NSIndexPath
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    
    CGSize cellSize = [cell systemLayoutSizeFittingSize:CGSizeMake(self.view.frame.size.width, 0) withHorizontalFittingPriority:1000.0 verticalFittingPriority:50.0];
    [self.rowHeights setObject:[NSNumber numberWithFloat:cellSize.height] forKey:indexPath];
 
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath;
    [self showWebViewAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSMutableIndexPath to NSIndexPath
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    if([self.rowHeights objectForKey:indexPath]){
        NSNumber *height = [self.rowHeights objectForKey:indexPath];
        return [height floatValue];
    }
    return 150.0;
}


#pragma mark - Utils

- (void)startActivityIndicator{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

- (void)stopActivityIndicator{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}

#pragma mark - IBAction

- (IBAction)userNameButtonPressed:(id)sender {
    
    NSInteger item = ((UIButton *)sender).tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];

    self.selectedRow = indexPath;
    
    NSNumber *itemNumber =  self.top100StoriesIds[item];
    NSDictionary *storyDescription = [self.storyDescriptions objectForKey:itemNumber];
    NSString *user = [storyDescription objectForKey:@"by"];
    
    PrepareProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrepareProfileViewController"];
    
    viewController.user = user;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}






@end
