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
#import <CoreLocation/CoreLocation.h>

@interface LMRGeoFencer ()

@property (strong, nonatomic) LMRDataStore *store;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) CLCircularRegion *fence;
@property (nonatomic) BOOL didStartMonitoring;

@end


@implementation LMRGeoFencer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.store =[LMRDataStore sharedDataStore];
        self.locationManager = [[CLLocationManager alloc]init];
        self.location = [[Location alloc]init];
    }
    return self;
}

-(void)setupFenceWithLocation:(Location*)location
{
    self.location = location;
    self.didStartMonitoring = NO;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.fence = [location createFence];
    
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self youHaveArrivedAlert];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"You have updated location");
    if (locations && [locations count] && !self.didStartMonitoring)
    {
        NSLog(@"You have updated location and started monitoring");
        self.didStartMonitoring = YES;
        [self.locationManager startMonitoringForRegion:self.fence];
        [self.locationManager requestStateForRegion:self.fence];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self errorAlertViewWithError:error];
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"You Have Exited The Region");
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"You Have Started Monitoring");
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        [self youHaveArrivedAlert];
    }
    else if (state == CLRegionStateUnknown)
    {
        
        NSDictionary *errorDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"Can Not Determine Location", NSLocalizedDescriptionKey, nil];
        NSError *error = [[NSError alloc]initWithDomain:@"manual error" code:400 userInfo:errorDictionary];
        [self errorAlertViewWithError:error];
    }
}

-(void)youHaveArrivedAlert
{
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"You Have Arrived At" message:self.location.name delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

-(void)errorAlertViewWithError:(NSError*)error
{
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];

    [alertview show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"You Have Arrived At"])
    {
        [self.locationManager stopMonitoringForRegion:self.fence];
        [self.locationManager stopUpdatingLocation];
    }
    else if ([alertView.title isEqualToString:@"Error"])
    {
        if (buttonIndex == 0)
        {
            [self.locationManager stopMonitoringForRegion:self.fence];
            [self.locationManager stopUpdatingLocation];
        }
        else if (buttonIndex == 2)
        {
            [self.locationManager startUpdatingLocation];
            [self.locationManager startMonitoringForRegion:self.fence];
            [self.locationManager requestStateForRegion:self.fence];
        }
    }
    
    
}

@end
