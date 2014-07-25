//
//  LMRDataStore.h
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LMRDataStore : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLCircularRegion *geofence;
@property (nonatomic) BOOL didStartMonitoring;

+ (instancetype) sharedDataStore;
- (void)save;

-(void)addLocationWithName:(NSString*)name
             StreetAddress:(NSString*)streetAddress
                      City:(NSString*)city
                   Country:(NSString*)country
                  Latitude:(float)latitude
                 Longitude:(float)longitude;
@end
