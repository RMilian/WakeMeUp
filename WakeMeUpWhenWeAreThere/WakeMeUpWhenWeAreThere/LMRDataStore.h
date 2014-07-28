//
//  LMRDataStore.h
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "LMRGeoFencer.h"



@interface LMRDataStore : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) LMRGeoFencer *geoFenceManager;
@property (strong, nonatomic) UIAlertView *alertView;
@property (nonatomic) BOOL authorized;


+ (instancetype) sharedDataStore;
- (void)save;
- (void)addLocationWithName:(NSString*)name
             StreetAddress:(NSString*)streetAddress
                      City:(NSString*)city
                   Zipcode:(NSString*)zipCode
                  Latitude:(float)latitude
                 Longitude:(float)longitude
                    Radius:(NSNumber *)radius;
@end

