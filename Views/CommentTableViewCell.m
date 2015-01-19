//
//  CommentTableViewCell.m
//  hn
//
//  Created by Marcin Kmieć on 10.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.commentsButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10.0, -10.0, -10.0, -10.0)];
    [self.authorButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10.0, -10.0, -10.0, -10.0)];
    
}

@end
