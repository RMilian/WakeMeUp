//
//  LMRViewController.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/23/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LMRDataStore.h"

@interface LMRViewController ()


@property (strong, nonatomic) LMRDataStore *store;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *streetField;
@property (nonatomic, weak) IBOutlet UITextField *cityField;
@property (nonatomic, weak) IBOutlet UITextField *countryField;
@property (nonatomic, weak) IBOutlet UIButton *fetchCoordinatesButton;


- (IBAction)fetchCoordinates:(id)sender;
- (IBAction)saveButtonTapped:(id)sender;

@end

@implementation LMRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.store = [LMRDataStore sharedDataStore];
    self.nameField.delegate = self;
    self.streetField.delegate = self;
    self.cityField.delegate = self;
    self.countryField.delegate = self;
    self.mapView.delegate = self;
 
    self.mapView.hidden = YES;
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
        if (error)NSLog(@"Error = %@",error.localizedDescription);
        if ([placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            self.latitude = coordinate.latitude;
            self.longitude = coordinate.longitude;
            [self displayLocation];
            
        }
    }];
    [self resignFirstResponder];
}

- (IBAction)saveButtonTapped:(id)sender
{
    [self.store addLocationWithName:self.nameField.text
                      StreetAddress:self.streetField.text
                               City:self.cityField.text
                            Country:self.countryField.text
                           Latitude:self.latitude
                          Longitude:self.longitude];
}

-(void)displayLocation
{
    [self.view endEditing:YES];
    [self.countryField resignFirstResponder];
    [self.cityField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.streetField resignFirstResponder];
    self.mapView.hidden = NO;
    CLLocationCoordinate2D location2d = CLLocationCoordinate2DMake(self.latitude,self.longitude);
    MKCoordinateRegion locationRegion = MKCoordinateRegionMakeWithDistance(location2d, 10000, 10000);
    [self.mapView setRegion:locationRegion animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location2d;
    point.title = self.nameField.text;
    [self.mapView addAnnotation:point];
    
}

@end
