//
//  LMRLocationsTableViewController.h
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/24/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface LMRLocationsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate,CLLocationManagerDelegate>


@end
