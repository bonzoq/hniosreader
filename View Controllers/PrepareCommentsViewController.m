//
//  PrepareCommentsViewController.m
//  hn
//
//  Created by Marcin Kmieć on 11.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "PrepareCommentsViewController.h"
#import <Firebase/Firebase.h>
#import "CommentsViewController.h"
#import "Utils.h"

@interface PrepareCommentsViewController () <UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property NSMutableDictionary *commentDescriptions;
@property NSArray *commentKids;
@property UIButton *backButton;
@property NSNumber *numberOfCommentsToGet;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation PrepareCommentsViewController

#pragma mark - CustomMethods

- (void)getDescriptionOfItem:(NSNumber *)itemNumber withIndex:(NSInteger)index andCount:(NSInteger)count{
        
        NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
        
        Firebase* dataRef = [[Firebase alloc] initWithUrl:urlString];
    
        [dataRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            if([snapshot.value isKindOfClass:[NSNull class]]){
                return;
            }
       
            NSMutableDictionary *responseDictionary = [snapshot.value mutableCopy];

            if([responseDictionary isKindOfClass:[NSDictionary class]] && [responseDictionary objectForKey:@"id"] != nil){
                    
                    NSString *string = [responseDictionary objectForKey:@"text"];
                    if(string == nil){
                        string = @"";
                    }
                    
                    NSAttributedString *attributedString= [Utils convertHTMLToAttributedString:string];
                    [responseDictionary setObject:attributedString forKey:@"attributedText"];
                    [self.commentDescriptions setObject:[responseDictionary copy] forKey:[NSNumber numberWithInteger:index]];
                    
                    if([self.commentDescriptions count] == count){
                        [self.activityIndicator stopAnimating];
                        [self performSegueToCommentTableViewController];
                    }
                
            }
            
            else{
                
                [self.activityIndicator stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Error has occured fetching data from server" delegate:self cancelButtonTitle:@"Go back" otherButtonTitles:nil];
                [alert show];
            }
            
           
            
        }
         withCancelBlock:^(NSError *error) {
             
             [self.activityIndicator stopAnimating];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Error has occured fetching data from server" delegate:self cancelButtonTitle:@"Go back" otherButtonTitles:nil];
             [alert show];
         }];


    
}

- (void)getCommentDescriptionsOfCommentsLimitedToFirst:(NSInteger)limit{
    
    NSInteger numberOfComments = [self.commentIDs count];
    self.commentDescriptions = [NSMutableDictionary new];
    
    NSInteger commentIndex = 0;
    
    if(limit > numberOfComments){
        limit = numberOfComments;
    }

    for(int i = 0; i < limit; i++){
         NSNumber *itemNumber = self.commentIDs[i];
         [self getDescriptionOfItem:itemNumber withIndex:commentIndex andCount:limit];
         commentIndex++;
    }
 
    
   
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.activityIndicator startAnimating];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"backButton2.png"];
    [self.backButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    [self.backButton addTarget:self
                        action:@selector(backButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.numberOfCommentsToGet = [NSNumber numberWithInteger:2];
    
    if([self.text length] > 0){
        [self performSegueToCommentTableViewController];
    }
    else{
        [self getCommentDescriptionsOfCommentsLimitedToFirst:[self.numberOfCommentsToGet integerValue]];
    }

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Enable swipe to go back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    //if user swiped to go back and in the mean time when the view was half-way slid to back comments were downloaded, segue to comments view controller did not happen 
    if([self.commentDescriptions count] == [self.numberOfCommentsToGet integerValue]){
        [self.activityIndicator stopAnimating];
        [self performSegueToCommentTableViewController];
    }
}



- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)performSegueToCommentTableViewController{
    
    CommentsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsViewController"];
    
    viewController.storyTitle = self.storyTitle;
    viewController.url = self.url;
    viewController.text = self.text;
    viewController.commentDescriptions = self.commentDescriptions;
    viewController.commentIDs = [NSMutableArray arrayWithArray:self.commentIDs];
    viewController.points = self.points;
    viewController.timePosted = self.timePosted;
    viewController.author = self.author;
    
    //push viewController removing self from the navigation stack
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [viewControllers removeObjectIdenticalTo:self];
    [viewControllers addObject:viewController];
    
    [self.navigationController setViewControllers: viewControllers animated: NO];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
