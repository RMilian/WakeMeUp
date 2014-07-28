//
//  LMRNotAuthorizedViewController.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/27/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRNotAuthorizedViewController.h"

@interface LMRNotAuthorizedViewController ()

@end

@implementation LMRNotAuthorizedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationAuthorization.text = self.locationAuthorizationP;
    self.locationServices.text = self.locationServicesP;
    self.reminderAuthorization.text = self.reminderAuthorizationP;
    self.regionMonitoring.text = self.regionMonitoringP;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
