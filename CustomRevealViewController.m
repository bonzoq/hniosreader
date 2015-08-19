//
//  CustomRevealViewController.m
//  hn
//
//  Created by Marcin Kmieć on 11.03.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import "CustomRevealViewController.h"
#import "TableViewController.h"

@implementation CustomRevealViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    TableViewController *mainViewController = (TableViewController *)self.frontViewController;
    
    mainViewController.top100StoriesIds = self.top100StoriesIds;
    mainViewController.storyDescriptions = self.storyDescriptions;
}

@end
