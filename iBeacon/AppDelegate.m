//
//  AppDelegate.m
//  iBeacon
//
//  Created by Brad on 11/17/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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

- (void)initTimer {
  
  // Create the location manager if this object does not
  // already have one.
  //if (nil == self.locationManager)
    //self.locationManager = [[CLLocationManager alloc] init];
  
   //self.locationManager.delegate = self;
  //[self.locationManager startMonitoringSignificantLocationChanges];
  
  if (self.timer == nil) {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(checkUpdates:)
                                                userInfo:nil
                                                 repeats:YES];
  }
}

- (void)checkUpdates:(NSTimer *)timer{
  NSLog(@"PING");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  
  UIApplication*    app = [UIApplication sharedApplication];
  
  __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
    [app endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
  }];
  
  // Start the long-running task and return immediately.
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    // Do the work associated with the task.
    self.timer = nil;
    [self initTimer];
    
  });
}

@end
