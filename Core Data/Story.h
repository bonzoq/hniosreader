//
//  Story.h
//  hn
//
//  Created by Marcin Kmieć on 04.01.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Story : NSManagedObject

@property (nonatomic, retain) NSString * storyId;
@property (nonatomic, retain) NSNumber * read;

@end
