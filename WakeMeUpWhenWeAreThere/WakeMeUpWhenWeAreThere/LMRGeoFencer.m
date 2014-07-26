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
#import "LMRMonitoringViewController.h"

@interface LMRGeoFencer ()

@property (strong, nonatomic) LMRDataStore *store;

@property (nonatomic) BOOL didEnterRegion;

@end


@implementation LMRGeoFencer

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.store =[LMRDataStore sharedDataStore];
        self.locationManager = [[CLLocationManager alloc]init];
    }
    return self;
}

-(void)setupFenceWithLocation:(Location*)location
{
    self.location = location;
    self.didAlert = NO;
    self.didEnterRegion = NO;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.fence = [location createFence];
    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringForRegion:self.fence];
    [self.locationManager requestStateForRegion:self.fence];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations && [locations count] && !self.didEnterRegion)
    {
        [self.locationManager requestStateForRegion:self.fence];
    }
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    self.didEnterRegion = YES;
    [self youHaveArrivedAlert];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringForRegion:self.fence];
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

    if (!self.didAlert)
    {
        self.didAlert = YES;
        self.store.alertView.title = @"You Have Arrived";
        [self.store.alertView addButtonWithTitle:@"OK"];
        [self.store.alertView show];
    }
}

-(void)errorAlertViewWithError:(NSError*)error
{

    if (!self.didAlert)
    {
        self.didAlert = YES;
        self.store.alertView.title = @"Error";
        self.store.alertView.message = [NSString stringWithFormat:@"%@",error.localizedDescription];
        [self.store.alertView addButtonWithTitle:@"Cancel"];
        [self.store.alertView addButtonWithTitle:@"Retry"];
        [self.store.alertView show];
    }
}

@end
