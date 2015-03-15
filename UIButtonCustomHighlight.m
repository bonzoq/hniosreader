//
//  UIButtonCustomHighlight.m
//  hn
//
//  Created by Marcin Kmieć on 15.03.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import "UIButtonCustomHighlight.h"

@implementation UIButtonCustomHighlight

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if(self.highlighted) {
        [self setAlpha:0.5];
    }
    else {
        [self setAlpha:1.0];
    }
}


@end
