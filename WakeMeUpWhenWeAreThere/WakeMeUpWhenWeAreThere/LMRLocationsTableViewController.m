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
#import "LMRMonitoringViewController.h"
#import "LMRNotAuthorizedViewController.h"

@interface LMRLocationsTableViewController ()

@property (strong, nonatomic) LMRDataStore *store;
@property (strong, nonatomic) NSFetchedResultsController *resultsController;
@property (strong, nonatomic) NSString *locationAuthorization;
@property (strong, nonatomic) NSString *locationServices;
@property (strong, nonatomic) NSString *regionMonitoring;
@property (strong, nonatomic) NSString *reminderAuthorization;

@end

@implementation LMRLocationsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.store = [LMRDataStore sharedDataStore];
    self.store.geoFenceManager = [[LMRGeoFencer alloc]init];
    [self configureResultController];
    [self checkForAuthorization];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self configureResultController];
    [self.resultsController performFetch:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Location *locationToDelete = [self.resultsController objectAtIndexPath:indexPath];
        [self.store.managedObjectContext deleteObject:locationToDelete];
        [self.store save];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
 
    }   
}

#pragma mark - NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"monitorSegue"])
    {
    LMRMonitoringViewController *nextVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Location *selectedLocation = [self.resultsController objectAtIndexPath:indexPath];
    nextVC.location = selectedLocation;
    }
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
    self.resultsController.delegate = self;
    [self.resultsController performFetch:nil];
}

-(void)checkForAuthorization
{
    self.store.authorized = YES;
    __weak typeof(self) weakSelf = self;
    
    if(![CLLocationManager locationServicesEnabled])
    {
        self.store.authorized = NO;
        self.locationServices = @"Location Services not Enabled";
        NSLog(@"Location Services not Enabled");
    }
    if(![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]])
    {
        self.store.authorized = NO;
        self.regionMonitoring = @"Region monitoring not Enabled";
        NSLog(@"Region monitoring not Enabled");
    }
    
    if (!([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusAuthorized)) {
        NSLog(@"Reminder Services not Enabled");
        [self.store.geoFenceManager.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            if (!granted)
            {
                weakSelf.store.authorized = NO;
                weakSelf.reminderAuthorization = @"Reminder Services not Authorized";
                [weakSelf checkLocationAuthorization];
            }
            else if (granted)
            {
                [weakSelf checkLocationAuthorization];
            }
        }];
    }
}


-(void)checkLocationAuthorization
{
   
    if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized))
    {
        [self.store.geoFenceManager.locationManager startUpdatingLocation];
        NSLog(@"App Not Authorized %u",[CLLocationManager authorizationStatus]);
        
    }
    else
    {
        if (self.store.authorized == NO) {
            __weak typeof(self) weakSelf = self;
            LMRNotAuthorizedViewController *noAuthVC = [[LMRNotAuthorizedViewController alloc]init];
            __weak typeof(LMRNotAuthorizedViewController) *weakNotAuthVC = noAuthVC;
            [self presentViewController:weakNotAuthVC animated:YES completion:^
             {
                 weakNotAuthVC.locationServices.text = weakSelf.locationServices;
                 weakNotAuthVC.reminderAuthorization.text = weakSelf.reminderAuthorization;
                 weakNotAuthVC.regionMonitoring.text = weakSelf.regionMonitoring;
                 weakNotAuthVC.locationAuthorization.text = weakSelf.locationAuthorization;
             }];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (!(status == kCLAuthorizationStatusAuthorized))
    {
        self.store.authorized = NO;
        self.locationAuthorization = @"Location Services Not Authorized";
        LMRNotAuthorizedViewController *noAuthVC = [[LMRNotAuthorizedViewController alloc]init];
        [self presentViewController:noAuthVC animated:YES completion:^
        {
            noAuthVC.locationServices.text = self.locationServices;
            noAuthVC.reminderAuthorization.text = self.reminderAuthorization;
            noAuthVC.regionMonitoring.text = self.regionMonitoring;
            noAuthVC.locationAuthorization.text = self.locationAuthorization;
        }];
    }
}

@end
