//
//  LMRViewController.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/23/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LMRViewController ()

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, weak) IBOutlet UITextField *streetField;
@property (nonatomic, weak) IBOutlet UITextField *cityField;
@property (nonatomic, weak) IBOutlet UITextField *countryField;
@property (nonatomic, weak) IBOutlet UIButton *fetchCoordinatesButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *coordinatesLabel;

- (IBAction)fetchCoordinates:(id)sender;


@end

@implementation LMRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchCoordinates:(id)sender{
if (!self.geocoder)
    {
    self.geocoder = [[CLGeocoder alloc] init];
    }
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@", self.streetField.text, self.cityField.text, self.countryField.text];
    
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            self.coordinatesLabel.text = [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
            
            if ([placemark.areasOfInterest count] > 0) {
                NSString *areaOfInterest = [placemark.areasOfInterest objectAtIndex:0];
                self.nameLabel.text = areaOfInterest;
            } else {
                self.nameLabel.text = @"No Area of Interest Was Found";
            }
        }
    }];
    [self resignFirstResponder];

}

@end
