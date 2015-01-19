//
//  ReachabilityManager.m
//  hn
//
//  Created by Marcin Kmieć on 08.11.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "ReachabilityManager.h"

@interface ReachabilityManager ()

@property Reachability *reachability;

@end

@implementation ReachabilityManager

+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - Memory Management
- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark - Class Methods
+ (BOOL)isReachable {
    return [[[ReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isUnreachable {
    return ![[[ReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark -  Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        _reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Start Monitoring
        [_reachability startNotifier];
    }
    
    return self;
}


@end
