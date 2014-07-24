//
//  LMRGeoFencer.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRGeoFencer.h"
#import "Location.h"

@implementation LMRGeoFencer

-(void)setupFenceWithLocation:(Location*)location
{
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //_didStartMonitoringRegion = NO;
    [self.locationManager startUpdatingLocation];
    
    CLLocation *location = [CLLocation]
    
}

@end
