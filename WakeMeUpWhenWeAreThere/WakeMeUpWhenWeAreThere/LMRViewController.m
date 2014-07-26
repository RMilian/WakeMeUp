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
@property (nonatomic, weak) IBOutlet UITextField *zipCodeField;
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
    self.zipCodeField.delegate = self;
    self.mapView.delegate = self;
 
    self.mapView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)fetchCoordinates:(id)sender{
    [self resignFirstResponder];
    [self findLocationWithCompletion:^void(BOOL found)
    {
    if (!found)
    {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Can't Find Location"
                                                       message:@"Please Re-enter"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
    [alertView show];
    }
    else
    {
    [self displayLocation];
    }
    }];
}

- (IBAction)saveButtonTapped:(id)sender
{
    [self resignFirstResponder];
    [self findLocationWithCompletion:^(BOOL found)
    {
        if (found)
        {
            [self.store addLocationWithName:self.nameField.text
                              StreetAddress:self.streetField.text
                                       City:self.cityField.text
                                    Zipcode:self.zipCodeField.text
                                   Latitude:self.latitude
                                  Longitude:self.longitude Radius:@100];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Can't Find Location"
                                                               message:@"Please Re-enter"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}



-(void)findLocationWithCompletion:(void (^)(BOOL))findCompletion
{
    if (!self.geocoder)
    {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@", self.streetField.text, self.cityField.text, self.zipCodeField.text];

    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            findCompletion(NO);
        }
        if ([placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.latitude = placemark.location.coordinate.latitude;
            self.longitude = placemark.location.coordinate.longitude;
            findCompletion(YES);
        }
    }];
}



-(void)displayLocation
{
    [self.view endEditing:YES];
    [self.zipCodeField resignFirstResponder];
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
