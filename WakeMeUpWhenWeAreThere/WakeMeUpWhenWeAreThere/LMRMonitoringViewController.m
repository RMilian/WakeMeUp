//
//  LMRMonitoringViewController.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/25/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRMonitoringViewController.h"
#import "LMRDataStore.h"

@interface LMRMonitoringViewController ()

@property (weak, nonatomic) IBOutlet UILabel *myLocationLabel;
- (IBAction)testButtonTapped:(id)sender;

@end

@implementation LMRMonitoringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.store = [LMRDataStore sharedDataStore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.store.geoFenceManager = [[LMRGeoFencer alloc]init];
    self.store.alertView = [[UIAlertView alloc]init];
    self.store.alertView.delegate = self;
    [self.store.geoFenceManager setupFenceWithLocation:self.location];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    self.myLocationLabel.text = [NSString stringWithFormat:@"LOC- %f  %f",self.store.geoFenceManager.fence.center.longitude,self.store.geoFenceManager.fence.center.latitude];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"You Have Arrived"])
    {
        NSLog(@"Arrived---------");
        [self.store.geoFenceManager.locationManager stopMonitoringForRegion:self.store.geoFenceManager.fence];
        [self.store.geoFenceManager.locationManager stopUpdatingLocation];
        [self.store.alertView dismissWithClickedButtonIndex:0 animated:YES];
        self.store.geoFenceManager.didAlert = NO;
        [self dismissViewControllerAnimated:YES completion:^{
           
        }];
    }
    else if ([alertView.title isEqualToString:@"Error"])
    {
        if (buttonIndex == 0)
        {
            NSLog(@"Error Cancel---------");
            [self.store.geoFenceManager.locationManager stopMonitoringForRegion:self.store.geoFenceManager.fence];
            [self.store.geoFenceManager.locationManager stopUpdatingLocation];
            [self.store.alertView dismissWithClickedButtonIndex:0 animated:NO];
            self.store.geoFenceManager.didAlert = NO;
            [self dismissViewControllerAnimated:YES completion:^{
               
            }];
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"Error Retry---------");
            [self.store.geoFenceManager.locationManager startUpdatingLocation];
            [self.store.geoFenceManager.locationManager startMonitoringForRegion:self.store.geoFenceManager.fence];
            [self.store.geoFenceManager.locationManager requestStateForRegion:self.store.geoFenceManager.fence];
            [self.store.alertView dismissWithClickedButtonIndex:1 animated:NO];
            self.store.geoFenceManager.didAlert = NO;
            self.store.alertView = [[UIAlertView alloc]init];
            self.store.alertView.delegate = self;
        }
    }
}

- (IBAction)testButtonTapped:(id)sender {
    NSLog(@"Test Button Tapped");
}
@end
