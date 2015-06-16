//
//  CircleView.h
//  bezierPath2
//
//  Created by Marcin Kmieć on 15.12.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CircleView : UIView

- (void)animateRadius;
- (void)animateRadiusShrink;
- (id)initWithFrame:(CGRect)frame CommentNumber:(NSNumber *)number color:(UIColor *)color andWasRead:(BOOL)wasRead;
- (void)changeReadStateTo:(BOOL)newState;
- (void)animateNewReadStateIfNecessary;
- (void)drawView;
- (void)allowAnimationStart;

@property UIColor *color;
@property NSNumber *commentNumber;

@property NSIndexPath *parentCellIndexPath;

@end
