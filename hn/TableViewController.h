//
//  TableViewController.h
//  hn
//
//  Created by Marcin on 08.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface TableViewController : UIViewController

@property NSMutableArray *top100StoriesIds;
@property NSMutableDictionary *storyDescriptions;

@end
