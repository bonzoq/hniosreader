//
//  PrepareCommentsViewController.h
//  hn
//
//  Created by Marcin Kmieć on 11.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrepareCommentsViewController : UIViewController

@property NSString *storyTitle;
@property NSString *url;
@property NSString *text;
@property NSString *points;
@property NSArray *commentIDs;
@property NSString *author;
@property NSNumber *timePosted;
@property CGFloat tableCellHeight;

@end
