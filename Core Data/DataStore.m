//
//  DataStore.m
//  hn
//
//  Created by Marcin Kmieć on 06.01.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import "DataStore.h"
#import "AppDelegate.h"
#import "Story.h"

@interface DataStore ()

@property NSManagedObjectContext *managedObjectContext;

@end

@implementation DataStore

#pragma mark - Initialization

+ (id)sharedManager {
    static DataStore *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}

#pragma mark - CoreData

- (BOOL)getReadStateForStoryId:(NSNumber *)storyId{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storyId == %@", [storyId stringValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedStories = [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    Story *storyFetched;
    
    if([fetchedStories count] > 0){
        storyFetched = [[_managedObjectContext executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
        return [storyFetched.read boolValue];
    }
    
    return NO;
}

- (void)saveStoryIfNotExistsWithId:(NSNumber *)storyId{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storyId == %@", [storyId stringValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedStories = [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    Story *storyFetched;
    
    if([fetchedStories count] > 0){
        storyFetched = [[_managedObjectContext executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
    }
    
    if(storyFetched == nil){
        Story *newStory = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:_managedObjectContext];
        newStory.storyId = [storyId stringValue];
        newStory.read = [NSNumber numberWithBool:NO];
        [_managedObjectContext save:nil];
    }
    
}


- (void)saveRead:(BOOL)read forStoryId:(NSNumber *)storyId{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storyId == %@", [storyId stringValue]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    
    NSArray *fetchedStories = [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    Story *storyFetched;
    
    if([fetchedStories count] > 0){
        storyFetched = [[_managedObjectContext executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
    }
    
    if(storyFetched != nil){
        storyFetched.read = [NSNumber numberWithBool:read];
    }
    
    else{
        Story *newStory = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:_managedObjectContext];
        newStory.storyId = [storyId stringValue];
        newStory.read = [NSNumber numberWithBool:read];
    }
    
    [_managedObjectContext save:&error];
    
}

@end
