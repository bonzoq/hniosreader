//
//  RandomColor.h
//  hn
//
//  Created by Marcin Kmieć on 23.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Colours.h"

@interface RandomColor : NSObject

+ (UIColor *)getRandomColorForNumber:(NSUInteger)number;

@end
