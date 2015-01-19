//
//  labelVIew.m
//  hn
//
//  Created by Marcin Kmieć on 10.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "labelVIew.h"

@implementation labelVIew

- (void)layoutSubviews
{
    self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    [super layoutSubviews];
}

@end
