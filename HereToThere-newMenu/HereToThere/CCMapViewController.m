//
//  CCMapViewController.m
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "CCMapViewController.h"
#import "CCRoundButton.h"
#import "CCMenuView.h"
#import "CCDrawingViewController.h"
#import "CCRouteController.h"

@interface CCMapViewController () <UIGestureRecognizerDelegate, MKMapViewDelegate, DrawingVCDelegate>

@property (strong, nonatomic) CCMenuView *menuView;
@property (weak, nonatomic) IBOutlet CCRoundButton *moreButton;
@property (weak, nonatomic) IBOutlet CCRoundButton *currentLocationButton;

@property (strong, nonatomic) UITapGestureRecognizer *closeMenuTap;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressToDraw;

@property (strong, nonatomic) CCDrawingViewController *drawableViewController;

@property (strong, nonatomic) MKRoute *routeToAdd;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D mainLocation;
@property (nonatomic) MKCoordinateSpan mapSpan;

@property (strong, nonatomic) UIActivityIndicatorView *routingIndicator;

- (IBAction)moreButtonPressed:(CCRoundButton *)sender;

@end 

@implementation CCMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialMapSetUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - helper methods

- (void)initialMapSetUp
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startUpdatingLocation];
    self.mainLocation = self.locationManager.location.coordinate;
    [self.locationManager stopUpdatingLocation];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self mapViewRegion];
    [self.view addSubview:self.mapView];
    
    [self.view bringSubviewToFront:self.moreButton];
    [self.view bringSubviewToFront:self.currentLocationButton];
    
    self.menuView = [[CCMenuView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height, self.view.
                                                                 bounds.size.width, 100)];
    [self.menuView.directionsButton addTarget:self action:@selector(showDirections:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.clearButton addTarget:self action:@selector(routeLineReturned:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuView];
    self.closeMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
    self.longPressToDraw = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForDrawing:)];
    self.longPressToDraw.delegate = self;
    self.longPressToDraw.minimumPressDuration = 0.8f;
    self.longPressToDraw.allowableMovement = 10.0;
    self.longPressToDraw.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:self.longPressToDraw];
}

- (void)mapViewRegion
{
    if (self.mainLocation.latitude) {
        MKCoordinateRegion mapRegion;
        mapRegion.center.latitude = self.mainLocation.latitude;
        mapRegion.center.longitude = self.mainLocation.longitude;
        self.mapSpan = MKCoordinateSpanMake(0.07, 0.07);
        mapRegion.span = self.mapSpan;
        [self.mapView setRegion:mapRegion];
    }
}

#pragma mark - animations

- (void)showMenuViewAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.4f animations:^{
            self.menuView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - 100, self.view.bounds.size.width,
                                             100);
            self.moreButton.alpha = 0.5f;
            self.currentLocationButton.alpha = 0.5;
        } completion:^(BOOL finished) {
            self.moreButton.alpha = 0.0f;
            self.currentLocationButton.alpha = 0.0f;
            [self.view addGestureRecognizer:self.closeMenuTap];
        }];
    }
}

- (void)hideDrawingViewController
{
    [self.drawableViewController removeFromParentViewController];
    [self.drawableViewController.view removeFromSuperview];
}

- (void)animateButtonFadeIn
{
    [UIView animateWithDuration:0.4f animations:^{
        self.moreButton.alpha = 1.0f;
        self.currentLocationButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - gesture recognizers

- (void)closeMenu:(UITapGestureRecognizer *)sender
{
    [UIView animateWithDuration:0.4f animations:^{
        self.menuView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height, self.view.bounds.size.width,
                                         100);
        self.moreButton.alpha = 1.0f;
        self.currentLocationButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.view removeGestureRecognizer:self.closeMenuTap];
    }];
    
}

- (void)longPressForDrawing:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.moreButton.alpha = 0.0f;
        self.currentLocationButton.alpha = 0.0f;

        if (!self.drawableViewController) {
            self.drawableViewController = [self createDrawableViewFromStoryboard];
        } else
        {
            [self.mapView removeOverlays:self.mapView.overlays];
            [self addChildViewController:self.drawableViewController];
            [self.view addSubview:self.drawableViewController.view];
            [self.drawableViewController didMoveToParentViewController:self];
        }
    }
}

#pragma mark - IBActions

- (IBAction)moreButtonPressed:(CCRoundButton *)sender
{
    [self showMenuViewAnimated:YES];
}

#pragma mark - Menu button methods

- (void)showDirections:(CCRoundButton *)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame = CGRectMake(self.view.bounds.size.width - 107, self.view.bounds.origin.y + 100, 107, 368);
        self.menuView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - 64.7f, self.view.bounds.size.width,
                                         64.7f);
        self.menuView.alpha = 0.0f;
        self.mapView.layer.borderColor = [[UIColor colorWithRed:112.f/255 green:128.f/255 blue:144.f/255 alpha:1.0f] CGColor];
        self.mapView.layer.borderWidth = 2.0;
    } completion:^(BOOL finished) {
        self.closeMenuTap.enabled = NO;
        [self updateViewConstraints];
    }];
}

- (void)routeLineReturned:(CCRoundButton *)sender
{
    if (self.mapView.overlays.count > 0) {
        [self.mapView removeOverlays:self.mapView.overlays];
        self.menuView.clearButton.enabled = NO;
        self.menuView.directionsButton.enabled = NO;
    }
}

#pragma mark - drawable view methods

- (CCDrawingViewController *)createDrawableViewFromStoryboard
{
    CCDrawingViewController *drawViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"routeDrawingVC"];
    [self addChildViewController:drawViewController];
    drawViewController.view.frame = self.view.bounds;
    [self.view addSubview:drawViewController.view];
    [drawViewController didMoveToParentViewController:self];
    drawViewController.delegate = self;
    
    return drawViewController;
}

#pragma mark - DrawingVCDelegateMethods

- (void)endDrawingWithNoLine
{
    [self hideDrawingViewController];
    [self animateButtonFadeIn];
}

#pragma mark - route controller methods

- (void)updateMapWithLineForRoute:(CCLine *)finishedLine    //get polyline from route controller
{
    if (finishedLine) {
        CLLocationCoordinate2D endCoord = [self.mapView convertPoint:finishedLine.endPoint toCoordinateFromView:self.mapView];
        [[CCRouteController sharedController] routeStart:self.locationManager.location.coordinate andEnd:endCoord];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMapWithPolyline:) name:@"routeLineReturned" object:nil];
    }
    
    if (!self.routingIndicator) {
        self.routingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.routingIndicator.hidesWhenStopped = YES;
        [self.mapView addSubview:self.routingIndicator];
    }
    self.routingIndicator.center = finishedLine.endPoint;
    
    [self.routingIndicator startAnimating];
    
    [self hideDrawingViewController];
    [self animateButtonFadeIn];
}

- (void)updateMapWithPolyline:(NSNotification *)notification //called when route controller returns
{
    if ([notification.name isEqualToString:@"routeLineReturned"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeLineReturned" object:nil];
        self.routeToAdd = [notification.userInfo objectForKey:@"routeInfo"];
        [self.mapView addOverlay:self.routeToAdd.polyline];
        if (self.routingIndicator.isAnimating) {
            [self.routingIndicator stopAnimating];
        }
        self.menuView.directionsButton.enabled = YES;
        self.menuView.clearButton.enabled = YES;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:self.routeToAdd.polyline];
    routeLineRenderer.strokeColor = [UIColor colorWithRed:112.f/255 green:128.f/255 blue:144.f/255 alpha:1.f];
    routeLineRenderer.lineWidth = 3;
    
    return routeLineRenderer;
}

- (void)closeDirectionsView:(id)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame = [[UIScreen mainScreen] bounds];
        self.moreButton.alpha = 1.0f;
        self.currentLocationButton.alpha = 1.0f;
        self.mapView.layer.borderWidth = 0.0;
    } completion:^(BOOL finished) {
        self.closeMenuTap.enabled = YES;
        self.menuView.alpha = 1.0;
        self.menuView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height, self.view.bounds.size.width, 100);
    }];
    
}

@end
