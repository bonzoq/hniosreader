//
//  HNTableViewCell.m
//  hn
//
//  Created by Marcin on 08.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "HNTableViewCell.h"
#import "UIButton+Extension.h"

@implementation HNTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.commentsButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10.0, -10.0, -10.0, -10.0)];
    [self.userNameButton setHitTestEdgeInsets:UIEdgeInsetsMake(0.0, -10.0, -10.0, -10.0)];

}

- (void)prepareForReuse{
    
    [super prepareForReuse];

}



@end
