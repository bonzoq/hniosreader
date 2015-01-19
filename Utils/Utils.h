//
//  Utils.h
//  hn
//
//  Created by Marcin Kmieć on 30.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSString *)timeAgoFromTimestamp:(NSNumber *)timestamp;
+ (NSString *)makeThisPieceOfHTMLBeautiful: (NSString *)htmlString withFont:(NSString *)fontName ofSize:(int)size;
+ (NSAttributedString *)convertHTMLToAttributedString:(NSString *)string;
@end
