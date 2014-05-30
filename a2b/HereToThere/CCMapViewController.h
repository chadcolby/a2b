//
//  CCMapViewController.h
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CCMapViewController : UIViewController

@property (strong, nonatomic)  MKMapView *mapView;

- (void)closeDirectionsView:(id)sender;

@end
