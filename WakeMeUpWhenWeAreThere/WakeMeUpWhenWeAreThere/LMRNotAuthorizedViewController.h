//
//  LMRNotAuthorizedViewController.h
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/27/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMRNotAuthorizedViewController : UIViewController

@property (strong, nonatomic) NSString *locationAuthorizationP;
@property (strong, nonatomic) NSString *locationServicesP;
@property (strong, nonatomic) NSString *regionMonitoringP;
@property (strong, nonatomic) NSString *reminderAuthorizationP;

@property (weak, nonatomic) IBOutlet UILabel *locationAuthorization;
@property (weak, nonatomic) IBOutlet UILabel *reminderAuthorization;
@property (weak, nonatomic) IBOutlet UILabel *regionMonitoring;
@property (weak, nonatomic) IBOutlet UILabel *locationServices;

@end
