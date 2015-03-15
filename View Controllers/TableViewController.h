//
//  TableViewController.h
//  hn
//
//  Created by Marcin on 08.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController

@property NSMutableArray *top100StoriesIds;
@property NSMutableDictionary *storyDescriptions;
@property NSNumber *shouldScrollToTop;

- (void)getStoryDescriptionsUsingNewIDs:(BOOL)usingNewIDs;

- (void)setHNStories;
- (void)setAskHNStories;
- (void)setShowHNStories;
- (void)setJobStories;

- (void)reloadAllData;

- (void)showHUD;

@end
