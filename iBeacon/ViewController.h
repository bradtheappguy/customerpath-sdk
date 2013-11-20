//
//  ViewController.h
//  iBeacon
//
//  Created by Brad on 11/17/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ProximityKit/ProximityKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, PKManagerDelegate> {
    CLLocationManager * _locationManager;
  CLLocation * _currentLocation;
  
  CLRegion *_closestRegion;
}

@property PKManager *proximityKitManager;

@end
