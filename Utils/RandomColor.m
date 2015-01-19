//
//  RandomColor.m
//  hn
//
//  Created by Marcin Kmieć on 23.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "RandomColor.h"


@implementation RandomColor

+ (UIColor *)getRandomColorForNumber:(NSUInteger)number{
    
    number %= 10;

    switch (number) {
        case 0:
            return [UIColor skyBlueColor];
            break;
        case 1:
            return [UIColor steelBlueColor];
            break;
        case 2:
            return [UIColor pastelBlueColor];
            break;
        case 3:
            return [UIColor mandarinColor];
            break;
        case 4:
            return [UIColor warmGrayColor];
            break;
        case 5:
            return [UIColor violetColor];
            break;
        case 6:
            return [UIColor pinkColor];
            break;
        case 7:
            return [UIColor tomatoColor];
            break;
        case 8:
            return [UIColor indianRedColor];
            break;
        case 9:
            return [UIColor peachColor];
            break;
        default:
            break;
    }
    
    return [UIColor blackColor];
}

@end
