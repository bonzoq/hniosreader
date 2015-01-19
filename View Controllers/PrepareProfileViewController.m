//
//  PrepareProfileViewController.m
//  hn
//
//  Created by Marcin Kmieć on 21.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "PrepareProfileViewController.h"
#import <Firebase/Firebase.h>
#import "ProfileViewController.h"

@interface PrepareProfileViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property FirebaseHandle userProfileHandle;
@property UIButton *backButton;
@property BOOL profileHasBeenDownloaded;
@property NSDictionary *profileDescription;

@end

@implementation PrepareProfileViewController

#pragma mark - CustomMethods

- (void)getUserProfileDescription{
    
    NSString *urlString = [@"https://hacker-news.firebaseio.com/v0/user/" stringByAppendingString:self.user];
    
    Firebase* myRootRef = [[Firebase alloc] initWithUrl:urlString];
    self.userProfileHandle = [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        
        [myRootRef removeObserverWithHandle:self.userProfileHandle];
        self.profileDescription = snapshot.value;
        self.profileHasBeenDownloaded = YES;
        
        [self.activityIndicator stopAnimating];
        [self performSegueToProfileViewController];
    }];
    
    
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    [self getUserProfileDescription];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"backButton2.png"];
    [self.backButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    [self.backButton addTarget:self
                        action:@selector(backButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.profileHasBeenDownloaded = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Enable swipe to go back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    //if user swiped to go back and in the mean time when the view was half-way slid to back profile was downloaded, segue to profile view view controller did not happen
    if(self.profileHasBeenDownloaded){
        [self.activityIndicator stopAnimating];
        [self performSegueToProfileViewController];
    }
}

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)performSegueToProfileViewController{
    
    ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    viewController.profileDescription = self.profileDescription;
    
    //push viewController removing self from the navigation stack
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [viewControllers removeObjectIdenticalTo:self];
    [viewControllers addObject:viewController];
    [self.navigationController setViewControllers: viewControllers animated: NO];

}

@end
