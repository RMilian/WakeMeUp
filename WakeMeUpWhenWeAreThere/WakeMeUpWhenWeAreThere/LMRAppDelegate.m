//
//  LMRAppDelegate.m
//  WakeMeUpWhenWeAreThere
//
//  Created by Leo Reubelt on 7/23/14.
//  Copyright (c) 2014 Leo Reubelt. All rights reserved.
//

#import "LMRAppDelegate.h"
#import "LMRDataStore.h"

@implementation LMRAppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

//    self.store = [LMRDataStore sharedDataStore];
//
//    if(![CLLocationManager locationServicesEnabled])
//    {
//        //You need to enable Location Services
//        NSLog(@"Location Services not Enabled");
//    }
//    if(![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]])
//    {
//        //Region monitoring is not available for this Class;
//        NSLog(@"Region monitoring not available not Enabled");
//    }
//    
//    if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
//        NSLog(@"App Not Authorized %u",[CLLocationManager authorizationStatus]);
//        CLLocationManager *tempLM = [[CLLocationManager alloc]init];
//        tempLM.delegate = self;
//        id temp = tempLM.location;
//        [tempLM startUpdatingLocation];
//    }
//    
//    if (!([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusAuthorized)) {
//        NSLog(@"Reminder Services not Enabled");
//        EKEventStore *tempEventStore = [[EKEventStore alloc]init];
//        [tempEventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
//            
//        }];
//    }


    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
