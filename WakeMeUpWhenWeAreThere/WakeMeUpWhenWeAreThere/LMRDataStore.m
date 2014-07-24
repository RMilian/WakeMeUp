//
//  LMRDataStore.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRDataStore.h"
#import <CoreData/CoreData.h>
#import "Location.h"

@implementation LMRDataStore

@synthesize managedObjectContext = _managedObjectContext;

+ (instancetype)sharedDataStore
{
    static LMRDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[LMRDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

- (void)save
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WakeMeUp.sqlite"];
    
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)addLocationWithName:(NSString*)name
             StreetAddress:(NSString*)streetAddress
                      City:(NSString*)city
                   Country:(NSString*)country
                  Latitude:(float)latitude
                 Longitude:(float)longitude
{
    Location *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                        inManagedObjectContext:self.managedObjectContext];
    
    newLocation.name = name;
    newLocation.streetAddress = streetAddress;
    newLocation.city = city;
    newLocation.country = country;
    newLocation.latitude = [NSNumber numberWithFloat:latitude];
    newLocation.longitude = [NSNumber numberWithFloat:longitude];
    
    [self save];
}


@end
