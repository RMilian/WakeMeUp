//
//  Location.h
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/26/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSNumber * fenceRadius;

-(CLCircularRegion*)createFence;

@end
