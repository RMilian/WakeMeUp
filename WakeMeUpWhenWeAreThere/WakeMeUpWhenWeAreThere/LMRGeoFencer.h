//
//  LMRGeoFencer.h
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LMRDataStore.h"

@class Location;

@interface LMRGeoFencer : NSObject <CLLocationManagerDelegate>


@property (strong, nonatomic) LMRDataStore *store;

-(void)setupFenceWithLocation:(Location*)location;

@end
