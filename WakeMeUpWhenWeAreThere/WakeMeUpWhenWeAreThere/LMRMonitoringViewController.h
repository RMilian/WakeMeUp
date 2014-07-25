//
//  LMRMonitoringViewController.h
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/25/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMRDataStore;

@interface LMRMonitoringViewController : UIViewController

@property (strong, nonatomic) LMRDataStore *store;

@end
