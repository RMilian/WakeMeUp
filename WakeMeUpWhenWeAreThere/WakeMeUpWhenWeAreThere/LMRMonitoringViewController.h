//
//  LMRMonitoringViewController.h
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/25/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMRDataStore;
@class Location;

@interface LMRMonitoringViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) LMRDataStore *store;
@property (strong, nonatomic) Location *location;

@end
