//
//  Location.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/26/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "Location.h"



@implementation Location

@dynamic city;
@dynamic zipCode;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic streetAddress;
@dynamic fenceRadius;

-(CLCircularRegion*)createFence
{
    CLLocationCoordinate2D location2d = CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
    CLLocationDistance radius = [self.fenceRadius floatValue];
    CLCircularRegion *fence = [[CLCircularRegion alloc]initWithCenter:location2d radius:radius identifier:@"region"];
    return fence;
}

-(EKStructuredLocation*)createStructuredLocation
{
    EKStructuredLocation *structuredLocation = [EKStructuredLocation locationWithTitle:@"structuredLocation"];
    CLLocation *locationForStructLoc = [[CLLocation alloc]initWithLatitude:[self.longitude floatValue] longitude:[self.latitude floatValue]];
    structuredLocation.geoLocation = locationForStructLoc;
    structuredLocation.radius = [self.fenceRadius floatValue];
    return structuredLocation;
}

-(EKAlarm*)createAlarm
{
    EKAlarm *alarm = [[EKAlarm alloc]init];
    alarm.proximity = EKAlarmProximityEnter;
    alarm.structuredLocation = [self createStructuredLocation];
    return alarm;
}


@end
