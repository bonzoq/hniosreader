//
//  HNTableViewCell.h
//  hn
//
//  Created by Marcin on 08.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton2Tags.h"

@interface HNTableViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (weak, nonatomic) IBOutlet UILabel *domainLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursAgoLabel;
@property (weak, nonatomic) IBOutlet UIButton2Tags *commentsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hoursAgoLabelLeadingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceConstraint;



@end
