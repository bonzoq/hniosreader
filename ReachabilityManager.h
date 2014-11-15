//
//  ReachabilityManager.h
//  hn
//
//  Created by Marcin Kmieć on 08.11.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

+ (ReachabilityManager *)sharedManager;
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
