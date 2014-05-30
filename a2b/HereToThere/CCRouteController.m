//
//  CCRouteController.m
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "CCRouteController.h"

@interface CCRouteController ()

@property (strong, nonatomic) MKRoute *requestedRoute;
@property (nonatomic) CLLocationCoordinate2D endCoordForRoute;
@property (nonatomic) CLLocationCoordinate2D startCoordForRoute;

@end

@implementation CCRouteController

+ (CCRouteController *)sharedController
{
    static dispatch_once_t pred;
    static CCRouteController *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[CCRouteController alloc] init];
    });
    
    return shared;
}

- (void)routeStart:(CLLocationCoordinate2D)startCoord andEnd:(CLLocationCoordinate2D)endCoord
{
    self.endCoordForRoute = endCoord;
    self.startCoordForRoute = startCoord;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:self.endCoordForRoute.latitude
                                                         longitude:self.endCoordForRoute.longitude];
    [geoCoder reverseGeocodeLocation:endLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error.description);
        } else {
            MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks lastObject]];
            MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoord addressDictionary:nil];
            MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
            [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:endPlacemark]];
            [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:startPlacemark]];
            directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
            MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
            [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                if (error) {
                    NSLog(@">>%@", error.description);
                } else
                {
                    self.requestedRoute = response.routes.lastObject;
                    NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:self.requestedRoute, @"routeInfo", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"routeLineReturned" object:self userInfo:userDict];
                    [self listSteps:self.requestedRoute];
                }
            }];
            
        }
    }];
}

- (void)listSteps:(MKRoute *)route
{
    if (route) {
        NSDictionary *stepsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:route.steps, @"routeInfo", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"routeStepsToDisplay" object:self userInfo:stepsDictionary];
        for (MKRouteStep *step in route.steps) {
            NSLog(@"In %f meters %@", step.distance, step.instructions);
        }
    }
}

@end
