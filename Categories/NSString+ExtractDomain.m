//
//  NSString+ExtractDomain.m
//  hn
//
//  Created by Marcin Kmieć on 08.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "NSString+ExtractDomain.h"

@implementation NSString (ExtractDomain)

- (NSString *)extractDomain
{
    
    // Convert the string to an NSURL to take advantage of NSURL's parsing abilities.
    NSURL * url = [NSURL URLWithString:self];
    
    // Get the host, e.g. "secure.twitter.com"
    NSString * host = [url host];
    host = [host stringByReplacingOccurrencesOfString:@"www." withString:@""];
    return host;

}

@end
