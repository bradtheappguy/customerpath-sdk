//
//  ViewController.m
//  iBeacon
//
//  Created by Brad on 11/17/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import <AdSupport/AdSupport.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *closestBeaconLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceToClosestLabel;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.proximityKitManager = [PKManager managerWithDelegate:self];
  [self.proximityKitManager start];
  
  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateUI) userInfo:Nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startTrackingButtonPressed:(id)sender {
  if (!_locationManager && [CLLocationManager locationServicesEnabled]) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = 0;
    _locationManager.delegate = self;
  }
  
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
  NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:filePath];
  
  static NSString *kBeaconsKey = @"Beacons";
  static NSString *kBeaconIdentifierKey = @"identifier";
  static NSString *kBeaconMajorKey = @"major";
  static NSString *kBeaconMinorKey = @"minor";
  static NSString *kBeaconUDIDKey = @"udid";
  
  static NSString *kLocationsKey = @"Locations";
  static NSString *kLoctionsLatitudeKey = @"lat";
  static NSString *kLoctionsLongitudeKey = @"lng";
  static NSString *kLoctionsRadiusKey = @"radius";
  
  NSArray *beacons = [data objectForKey:kBeaconsKey];
  for (NSDictionary *beacon in beacons) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:beacon[kBeaconUDIDKey]];
    CLBeaconMajorValue major = [beacon[kBeaconMajorKey] integerValue];
    CLBeaconMinorValue minor = [beacon[kBeaconMinorKey] integerValue];
    NSString *identifer = beacon[kBeaconIdentifierKey];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                           major:major
                                                                           minor:minor
                                                                     identifier:identifer];
    [_locationManager startMonitoringForRegion:beaconRegion];
  }
  
  for (NSDictionary *location in [data objectForKey:kLocationsKey]) {
    
    CLLocationDegrees latitude = [location[kLoctionsLatitudeKey] floatValue];
    CLLocationDegrees longitude = [location[kLoctionsLongitudeKey] floatValue];
    CLLocationDistance radius = [location[kLoctionsRadiusKey] floatValue];
    NSString *identifier = location[kBeaconIdentifierKey];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
    [_locationManager startMonitoringForRegion:region];
  }
  
  [_locationManager startUpdatingLocation];
}

#pragma mark CLLocation

/*
 *  locationManager:didUpdateLocations:
 *
 *  Discussion:
 *    Invoked when new locations are available.  Required for delivery of
 *    deferred locations.  If implemented, updates will
 *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
 *
 *    locations is an array of CLLocation objects in chronological order.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations  {
    _currentLocation = [locations firstObject];
    self.currentLocationLabel.text = _currentLocation.debugDescription;
  [self phoneHome];
}


/*
 *  locationManager:didDetermineState:forRegion:
 *
 *  Discussion:
 *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
 *    a call to requestStateForRegion:.
 */
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
  
}

/*
 *  locationManager:didRangeBeacons:inRegion:
 *
 *  Discussion:
 *    Invoked when a new set of beacons are available in the specified region.
 *    beacons is an array of CLBeacon objects.
 *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
 *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
 *    by the device.
 */
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
  
}

/*
 *  locationManager:rangingBeaconsDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error {
  
}

/*
 *  locationManager:didEnterRegion:
 *
 *  Discussion:
 *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
  
}

/*
 *  locationManager:didExitRegion:
 *
 *  Discussion:
 *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
  
}

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  
}

/*
 *  locationManager:monitoringDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error {
  
}

/*
 *  locationManager:didChangeAuthorizationStatus:
 *
 *  Discussion:
 *    Invoked when the authorization status changes for this application.
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
}

/*
 *  locationManager:didStartMonitoringForRegion:
 *
 *  Discussion:
 *    Invoked when a monitoring for a region started successfully.
 */
- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region {
  
}

/*
 *  Discussion:
 *    Invoked when location updates are automatically paused.
 */
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
  
}

/*
 *  Discussion:
 *    Invoked when location updates are automatically resumed.
 *
 *    In the event that your application is terminated while suspended, you will
 *	  not receive this notification.
 */
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
  
}

/*
 *  locationManager:didFinishDeferredUpdatesWithError:
 *
 *  Discussion:
 *    Invoked when deferred updates will no longer be delivered. Stopping
 *    location, disallowing deferred updates, and meeting a specified criterion
 *    are all possible reasons for finishing deferred updates.
 *
 *    An error will be returned if deferred updates end before the specified
 *    criteria are met (see CLError).
 */
- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(NSError *)error {
  
}

#pragma mark UI

-(void) phoneHome {
  
  
  /*
   "beacons": "123",
   "longitude": "2",
   "latitude": "2",
   "email": "test@test.com",
   "ifa": "123",
   "storeId": "123"
   */
  
  NSString *ifa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
  
  NSDictionary *data = @{@"beacons": _closestRegion.identifier?_closestRegion.identifier:@"null",
                         @"longitude": [NSString stringWithFormat:@"%f",_currentLocation.coordinate.longitude],
                         @"latitude": [NSString stringWithFormat:@"%f",_currentLocation.coordinate.latitude],
                         @"email": @"brad@radiumone.com",
                         @"ifa": ifa,
                         @"storeId": @"123"};
  
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
  
  
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://customerpath.herokuapp.com/ping/"]];
  [req setHTTPMethod:@"POST"];
  [req addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:jsonData];
  
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
      if ([(NSHTTPURLResponse *)response statusCode] == 200) {
        NSError *error = nil;
        id x = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (!error) {
          NSLog(@"response: %@",x);
        }
        else {
          NSLog(@"Error fetching regions: %@",[error localizedDescription]);
        }
      }
    }];
}


-(void) updateUI {
    NSSet *activeRegions = [_locationManager monitoredRegions];

    CLLocationDistance shortestDistanceToCenterOfRegion = DBL_MAX;
    CLCircularRegion *closestRegion = nil;

    for(CLRegion *region in activeRegions.allObjects) {
        if ([region isKindOfClass:[CLCircularRegion class]]) {
            CLCircularRegion *circularRegion = region;
            CLLocation *centerOfRegion = [[CLLocation alloc] initWithLatitude:circularRegion.center.latitude longitude:circularRegion.center.longitude];
            CLLocationDistance distanceToCenterOfRegion = [_currentLocation distanceFromLocation:centerOfRegion];
            if (distanceToCenterOfRegion < shortestDistanceToCenterOfRegion) {
                shortestDistanceToCenterOfRegion = distanceToCenterOfRegion;
                closestRegion = region;
            }
          NSLog(@"Distance to center of region (%f,%f):\n %f",circularRegion.center.latitude, circularRegion.center.longitude, distanceToCenterOfRegion);
        }
    }
    NSLog(@"Monitoring %d regions",activeRegions.count);
    NSLog(@"Ranging %d beacons",activeRegions.count);

    self.closestBeaconLabel.text = [NSString stringWithFormat:@"(%f,%f)",closestRegion.center.latitude, closestRegion.center.longitude];
  _closestRegion = closestRegion;
  self.distanceToClosestLabel.text = [NSString stringWithFormat:@"%f meters", shortestDistanceToCenterOfRegion];
  
  
  [self phoneHome];
}


#pragma mark ProxKit
- (void)proximityKit:(PKManager *)manager didEnter:(PKRegion *)region {
  [[[UIAlertView alloc] initWithTitle:@"Entered REgion" message:region.name delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
  NSLog(@"entered %@", region);
  
  UILocalNotification *beginNotification = [[UILocalNotification alloc] init];
  if (beginNotification) {
    beginNotification.fireDate = [NSDate date];
    beginNotification.timeZone = [NSTimeZone defaultTimeZone];
    beginNotification.repeatInterval = 0;
    beginNotification.alertBody = [NSString stringWithFormat:@"Entered %@",region.name];
    beginNotification.soundName = UILocalNotificationDefaultSoundName;
    // this will schedule the notification to fire at the fire date
    //[app scheduleLocalNotification:notification];
    // this will fire the notification right away, it will still also fire at the date we set
    [[UIApplication sharedApplication] scheduleLocalNotification:beginNotification];
  }
  
  
}
- (void)proximityKit:(PKManager *)manager didExit:(PKRegion *)region {
   [[[UIAlertView alloc] initWithTitle:@"Exited REgion" message:region.name delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
  NSLog(@"exited %@", region);
}

@end