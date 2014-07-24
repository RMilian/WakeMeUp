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

@property (strong, nonatomic) CLCircularRegion *region;


@end


@implementation LMRGeoFencer

-(void)setupFenceWithLocation:(Location*)location
{
    self.store = [LMRDataStore sharedDataStore];
    self.store.didStartMonitoring = NO;
        
    [self.store.locationManager setDelegate:self];
    [self.store.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.store.locationManager startUpdatingLocation];
    
    CLLocationCoordinate2D location2d = CLLocationCoordinate2DMake([location.latitude floatValue], [location.longitude floatValue]);
    CLLocationDistance distance = 100.0;
    self.region = [[CLCircularRegion alloc]initWithCenter:location2d radius:distance identifier:@"region"];
    NSLog(@"location manager set up");
    //[self.store.locationManager startMonitoringForRegion:self.region];
    
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"You Are There" message:@"Fucker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{   
    if (locations && [locations count] && !self.store.didStartMonitoring)
    {
         self.store.didStartMonitoring = YES;
        [self.store.locationManager startMonitoringForRegion:self.region];
        [self.store.locationManager stopUpdatingLocation];
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
