//
//  LMRGeoFencer.h
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Location;

@interface LMRGeoFencer : NSObject <CLLocationManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) CLCircularRegion *fence;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL didAlert;

-(void)setupFenceWithLocation:(Location*)location;

@end
