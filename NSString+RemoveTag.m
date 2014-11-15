//
//  NSString+RemoveTag.m
//  hn
//
//  Created by Marcin on 05.11.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "NSString+RemoveTag.h"

@implementation NSString (RemoveTag)

- (NSString *)stringByRemovingTag:(NSString *)tag{
    NSString *closingTag = [tag stringByReplacingOccurrencesOfString:@"<" withString:@"</"];
    NSString *string = [self stringByReplacingOccurrencesOfString:tag withString:@""];
    string = [string stringByReplacingOccurrencesOfString:closingTag withString:@""];
    return string;
}

- (NSString *)stringByRemovingOpeningTag:(NSString *)tag withClosingTag:(NSString *)closingTag{
    NSString *string = [self stringByReplacingOccurrencesOfString:tag withString:@""];
    string = [string stringByReplacingOccurrencesOfString:closingTag withString:@""];
    return string;
}

@end
