//
//  CCRouteController.h
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CCRouteController : NSObject

+ (CCRouteController *)sharedController;

- (void)routeStart:(CLLocationCoordinate2D)startCoord andEnd:(CLLocationCoordinate2D)endCoord;

@end
