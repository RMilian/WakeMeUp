//
//  LMRGeoFencer.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRGeoFencer.h"
#import "Location.h"
#import "LMRDataStore.h"

@interface LMRGeoFencer ()

//@property (strong, nonatomic) CLCircularRegion *region;

@end


@implementation LMRGeoFencer

-(void)setupFenceWithLocation:(Location*)location
{
    self.store = [LMRDataStore sharedDataStore];
    self.store.didStartMonitoring = NO;
        
    self.store.locationManager.delegate = self;
    self.store.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.store.locationManager startUpdatingLocation];
    
    CLLocationCoordinate2D location2d = CLLocationCoordinate2DMake([location.latitude floatValue], [location.longitude floatValue]);
    NSLog(@"distance %f",self.store.locationManager.maximumRegionMonitoringDistance);
    NSLog(@"long/lat = %f %f",location2d.longitude, location2d.latitude);
    
    CLLocationDistance distance = 1000.0;
    
    
    self.store.geofence = [[CLCircularRegion alloc]initWithCenter:location2d radius:distance identifier:@"region"];
    NSLog(@"store long/lat = %f  %f",self.store.geofence.center.longitude, self.store.geofence.center.latitude);
    
    if(![CLLocationManager locationServicesEnabled])
    {
        //You need to enable Location Services
        NSLog(@"Location Services not Enabled");
    }
    if(![CLLocationManager isMonitoringAvailableForClass:[self.store.geofence class]])
    {
        //Region monitoring is not available for this Class;
        NSLog(@"Region monitoring not available not Enabled");
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
    {
        NSLog(@"App Not Authorized");
        //You need to authorize Location Services for the APP
    }
    
    [self.store.locationManager startMonitoringForRegion:self.store.geofence];

    [self.store.locationManager requestStateForRegion:self.store.geofence];
    NSLog(@"break");
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"You Are There" message:@"Fucker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
    NSLog(@"EnteringXXXXXXXXXX");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{   
    if (locations && [locations count] && !self.store.didStartMonitoring)
    {
         self.store.didStartMonitoring = YES;
        [self.store.locationManager startMonitoringForRegion:self.store.geofence];
        //[self.store.locationManager stopUpdatingLocation];
        [self.store.locationManager requestStateForRegion:self.store.geofence];
    }
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"You Are There" message:@"Fucker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if (state == CLRegionStateUnknown)
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Unknown" message:@"Fucker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }
}

@end
