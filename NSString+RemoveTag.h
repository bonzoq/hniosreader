//
//  NSString+RemoveTag.h
//  hn
//
//  Created by Marcin on 05.11.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RemoveTag)

- (NSString *)stringByRemovingTag:(NSString *)tag;
- (NSString *)stringByRemovingOpeningTag:(NSString *)tag withClosingTag:(NSString *)closingTag;

@end
