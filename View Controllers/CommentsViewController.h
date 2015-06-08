//
//  CommentsViewController.h
//  hn
//
//  Created by Marcin Kmieć on 09.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentsViewControllerDelegate <NSObject>

- (void)storyWasRead;

@end

@interface CommentsViewController : UIViewController

@property NSString *storyTitle;
@property NSString *url;
@property NSString *text;
@property NSMutableDictionary *commentDescriptions;
@property NSMutableArray *commentIDs;
@property NSString *points;
@property NSString *author;
@property NSNumber *timePosted;
@property (nonatomic, weak) id <CommentsViewControllerDelegate> delegate;

@end
