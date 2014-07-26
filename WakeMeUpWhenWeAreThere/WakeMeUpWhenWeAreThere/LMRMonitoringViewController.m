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
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.store = [LMRDataStore sharedDataStore];
    
    self.myLocationLabel.text = [NSString stringWithFormat:@"LOC- %f  %f",self.store.geoFenceManager.fence.center.longitude,self.store.geoFenceManager.fence.center.latitude];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)testButtonTapped:(id)sender {
    NSLog(@"Test Button Tapped");
}
@end
