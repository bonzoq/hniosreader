//
//  PrepareStoriesViewController.m
//  hn
//
//  Created by Marcin Kmieć on 01.11.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "PrepareStoriesViewController.h"
#import <Firebase/Firebase.h>
#import "TableViewController.h"
#import "ReachabilityManager.h"
#import "CustomRevealViewController.h"

@interface PrepareStoriesViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSArray *top100StoriesIds;
@property NSMutableDictionary *storyDescriptions;

@property UIAlertView *alertView;
@property NSTimer *timer;
@property NSMutableArray *firebaseRefs;
@property NSNumber *numberOfStoriesToLoad;

@property NSDate *veryFirstDate;

@end

@implementation PrepareStoriesViewController

#pragma mark - FireBase SDK

- (void)loadStoriesLimitedTo:(NSInteger)limit{
    
    self.firebaseRefs = [NSMutableArray new];
    
    [self startActivityIndicator];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(firebaseRequestDidTimeOut:)
                                   userInfo:nil
                                    repeats:NO];
        NSDate *startDate = [NSDate date];
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://hacker-news.firebaseio.com/v0/topstories"];
    
    [self.firebaseRefs addObject:ref];

       [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDate *endDate = [NSDate date];

        [self.timer invalidate];
        
        if([snapshot.value isKindOfClass:[NSArray class]]){
            self.top100StoriesIds = snapshot.value;
            [self getDescriptionOfStoriesLimitedTo:limit];
        }
        else{
            [self.timer invalidate];
            [self stopActivityIndicator];
            if(self.alertView == nil){
                self.alertView = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Error has occured fetching data from server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [self.alertView show];
            }
        }
    }
                                
    withCancelBlock:^(NSError *error) {
        [self.timer invalidate];
        [self stopActivityIndicator];
        if(self.alertView == nil){
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Error has occured fetching data from server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.alertView show];
        }
    }];
    
}



- (void)getStoryDataOfItem:(NSNumber *) itemNumber withNumberOfStoriesToGet:(NSInteger)numberOfStoriesToGet{
    
            NSDate *startDate = [NSDate date];
            NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
            Firebase *dataRef = [[Firebase alloc] initWithUrl:urlString];
            [self.firebaseRefs addObject:dataRef];

            [dataRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
    
                NSDate *endDate = [NSDate date];
                //NSLog(@"1 in %f",[endDate timeIntervalSinceDate:startDate]);
                
                NSDictionary *responseDictionary = snapshot.value;
                
                if([responseDictionary isKindOfClass:[NSDictionary class]] && [responseDictionary objectForKey:@"id"] != nil){
                    
                        [self.storyDescriptions setObject:responseDictionary forKey:itemNumber];
                    
                        if([self.storyDescriptions count] == numberOfStoriesToGet){
                            [self stopActivityIndicator];
                            [self.timer invalidate];
                            
                            NSDate *leaveDate = [NSDate date];
                            
                           //NSLog(@"Total: %fs", [leaveDate timeIntervalSinceDate:self.veryFirstDate]);
                            
                            [self performSegueWithIdentifier:@"storiesViewController" sender:self];
                        }
                  
                }
                else{
                    [self.timer invalidate];
                    if(self.alertView == nil){
                        self.alertView = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Error has occured fetching data from server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [self.alertView show];
                    }
                }
            }
             withCancelBlock:^(NSError *error) {
                 [self.timer invalidate];
                 if(self.alertView == nil){
                     self.alertView = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Error has occured fetching data from server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [self.alertView show];
                 }
             }
             ];

    
    
}

- (void)getDescriptionOfStoriesLimitedTo:(NSInteger) limit{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                  target:self
                                                selector:@selector(firebaseRequestDidTimeOut:)
                                                userInfo:nil
                                                 repeats:NO];
    
    for(int i = 0; i < limit; i++){
        NSNumber *itemNumber = self.top100StoriesIds[i];
        [self getStoryDataOfItem:itemNumber withNumberOfStoriesToGet:limit];
    }
    
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.veryFirstDate = [NSDate date];
    
    self.numberOfStoriesToLoad = [NSNumber numberWithInteger:6];
    
    self.storyDescriptions = [NSMutableDictionary new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [self loadStoriesLimitedTo:[self.numberOfStoriesToLoad integerValue]];
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"storiesViewController"]){
        CustomRevealViewController *viewController = (CustomRevealViewController *)segue.destinationViewController;
        viewController.top100StoriesIds = [self.top100StoriesIds mutableCopy];
        viewController.storyDescriptions = self.storyDescriptions;
    }
}

#pragma mark - Utils

- (void)startActivityIndicator{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    [self.activityIndicator startAnimating];
}

- (void)stopActivityIndicator{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    [self.activityIndicator stopAnimating];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.alertView = nil;
    for(Firebase *ref in self.firebaseRefs){
        [ref removeAllObservers];
    }
    [self loadStoriesLimitedTo:[self.numberOfStoriesToLoad integerValue]];
}

#pragma mark - NSNotificationCenter

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        
    }
    else
    {
        [self stopActivityIndicator];
        [self.timer invalidate];
        
        if(self.alertView == nil){
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"The internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.alertView show];
        }

    }
}

#pragma mark - NSTimerDelegate

-(void)firebaseRequestDidTimeOut:(NSTimer *)timer {

    [timer invalidate];
    for(Firebase *ref in self.firebaseRefs){
        [ref removeAllObservers];
    }
    
    NSString *message;
    
    if( [ReachabilityManager isReachable]){
        message = @"Error has occured fetching data from server";
    }
    else{
        message = @"The internet connection appears to be offline";
    }
    
    [self stopActivityIndicator];
    if(self.alertView == nil){
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.alertView show];
    }
    
    
}

@end
