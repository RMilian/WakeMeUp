//
//  LMRLocationsTableViewController.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRLocationsTableViewController.h"
#import "LMRDataStore.h"
#import "Location.h"
#import "LMRGeoFencer.h"

@interface LMRLocationsTableViewController ()

@property (strong, nonatomic) LMRDataStore *store;
@property (strong, nonatomic) NSFetchedResultsController *resultsController;

@end

@implementation LMRLocationsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.store = [LMRDataStore sharedDataStore];
    self.store.geoFenceManager = [[LMRGeoFencer alloc]init];
    self.resultsController.delegate = self;
    [self configureResultController];
    [self.resultsController performFetch:nil];
    [self.tableView reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.resultsController performFetch:nil];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [self.resultsController.sections[section] numberOfObjects];
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Location *currentLocation = [self.resultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = currentLocation.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *location = [self.resultsController objectAtIndexPath:indexPath];
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Location *selectedLocation = [self.resultsController objectAtIndexPath:indexPath];
    LMRGeoFencer *fencer = [[LMRGeoFencer alloc]init];
    [fencer setupFenceWithLocation:selectedLocation];
}


-(void)configureResultController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    
    NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[alphaSort];

    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:self.store.managedObjectContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    [self.resultsController performFetch:nil];
}




-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"You Are There" message:@"Fucker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
    NSLog(@"EnteringXXXXXXXXXX");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations && [locations count] && !self.store.didStartMonitoring)
    {
        self.store.didStartMonitoring = YES;
        [self.store.locationManager startMonitoringForRegion:self.store.geofence];
        //[self.store.locationManager stopUpdatingLocation];
        [self.store.locationManager requestStateForRegion:self.store.geofence];
    }
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"You Are There" message:@"Fucker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if (state == CLRegionStateUnknown)
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Unknown" message:@"Fucker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }
}


@end
