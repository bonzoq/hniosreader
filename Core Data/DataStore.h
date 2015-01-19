//
//  DataStore.h
//  hn
//
//  Created by Marcin Kmieć on 06.01.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

+ (id)sharedManager;

- (BOOL)getReadStateForStoryId:(NSNumber *)storyId;
- (void)saveStoryIfNotExistsWithId:(NSNumber *)storyId;
- (void)saveRead:(BOOL)read forStoryId:(NSNumber *)storyId;

@end
