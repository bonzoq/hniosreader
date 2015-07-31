//
//  CircleView.m
//  bezierPath
//
//  Created by Marcin Kmieć on 15.12.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "CircleView.h"
#import "QuartzCore/QuartzCore.h"

#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

@implementation CircleView{

CAShapeLayer *backgroundLayer;
CAShapeLayer *ringLayer;
CGFloat radius;
UILabel *numberLabel;
BOOL storyWasRead;
BOOL newReadState;

BOOL viewBeingAnimated;
    
BOOL startAnimating;
    
}

- (void)allowAnimationStart{
    startAnimating = YES;
}

- (void)animateNewReadStateIfNecessary{
    
    if(viewBeingAnimated == NO){

        [self drawViewFilled:storyWasRead];
        
        if(storyWasRead != newReadState && startAnimating){
            
            startAnimating = NO;
            
            storyWasRead = newReadState;
            
            viewBeingAnimated = YES;
            
            if(storyWasRead == YES){
                [self animateRadius];
            }
            else{
                [self animateRadiusShrink];
            }
        }
        
    }
}

- (void)changeReadStateTo:(BOOL)newState{

    newReadState = newState;
}

- (id)initWithFrame:(CGRect)frame CommentNumber:(NSNumber *)number color:(UIColor *)color andWasRead:(BOOL)wasRead{
    self = [super initWithFrame: frame];
    if(self){
        self.color = color;
        self.commentNumber = number;
        storyWasRead = wasRead;
        newReadState = wasRead;
        viewBeingAnimated = NO;
        startAnimating = NO;
        
        backgroundLayer = [CAShapeLayer new];
        backgroundLayer.fillColor = self.color.CGColor;
        [self.layer addSublayer:backgroundLayer];
        
        ringLayer = [CAShapeLayer new];
        ringLayer.frame = backgroundLayer.frame;
        ringLayer.strokeColor = self.color.CGColor;
        ringLayer.lineWidth = 1;
        ringLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:ringLayer];
        
        numberLabel = [[UILabel alloc] initWithFrame:self.layer.bounds];
        numberLabel.text = [NSString stringWithFormat:@"%@", self.commentNumber];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [self addSubview:numberLabel];
    }
   return self;
}

- (void)drawView{
   
    [self drawViewFilled:storyWasRead];
}

- (void)drawViewFilled:(BOOL)filled{
    
    
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                         radius:filled ? self.frame.size.width/2 : 0.011
                                                     startAngle:0.0
                                                       endAngle:DEGREES_TO_RADIANS(360)
                                                      clockwise:YES];
    backgroundLayer.path = aPath.CGPath;
    
    UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                         radius:self.frame.size.width/2 - 1
                                                     startAngle:0.0
                                                       endAngle:DEGREES_TO_RADIANS(360)
                                                      clockwise:YES];
    ringLayer.path = bPath.CGPath;
    
    numberLabel.textColor = filled ? [UIColor whiteColor]: self.color;
}


- (void)animateRadius{
    
  
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                         radius:self.frame.size.width/2
                                                     startAngle:0.0
                                                       endAngle:DEGREES_TO_RADIANS(360)
                                                      clockwise:YES];
    
    CABasicAnimation *morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.removedOnCompletion = NO;
    morph.fillMode = kCAFillModeForwards;
    morph.duration = 0.1;
    morph.toValue = (id)aPath.CGPath;
    
    [CATransaction begin];
    numberLabel.textColor = [UIColor whiteColor];
    
    [CATransaction setCompletionBlock:^{
        viewBeingAnimated = NO;
        startAnimating = NO;
    }];
    
    [backgroundLayer addAnimation:morph forKey:nil];
    
    
    [CATransaction commit];
}

- (void)animateRadiusShrink{
    
    
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                         radius:0.0111
                                                     startAngle:0.0
                                                       endAngle:DEGREES_TO_RADIANS(360)
                                                      clockwise:YES];
    
    CABasicAnimation *morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.removedOnCompletion = NO;
    morph.fillMode = kCAFillModeForwards;
    morph.duration = 0.1;
    morph.toValue = (id)aPath.CGPath;
    
    numberLabel.textColor = self.color;
    
    [CATransaction begin];
    
    
    [CATransaction setCompletionBlock:^{
        
        viewBeingAnimated = NO;
        startAnimating = NO;
        
    }];
        
    [backgroundLayer addAnimation:morph forKey:nil];
    [CATransaction commit];
    
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect frame = CGRectInset(self.bounds, -10, -10);
    
    return CGRectContainsPoint(frame, point) ? self : nil;
}



@end
