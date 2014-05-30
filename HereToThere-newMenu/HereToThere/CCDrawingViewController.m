//
//  CCDrawingViewController.m
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "CCDrawingViewController.h"

@interface CCDrawingViewController ()  <MapPointsFromDrawnLine>

- (IBAction)routeButtonPressed:(id)sender;
- (IBAction)backToMapButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet CCRoundButton *backToMapButton;
@property (weak, nonatomic) IBOutlet CCRoundButton *routeButton;

@property (strong, nonatomic) NSOperationQueue *routeQueue;
@property (strong, nonatomic) CCLine *lineForRoute;

@end

@implementation CCDrawingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initialSetUp];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self easeButtonsIn];
    self.routeButton.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self easeButtonsOut];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)initialSetUp
{
    self.drawView = (CCDrawView *)self.view;
    self.drawView.delegate = self;
    self.backToMapButton.alpha = 0.0f;
    self.routeButton.alpha = 0.0f;
    self.routeButton.enabled = NO;
    
}

#pragma mark - MapPointFromDrawnLine methods

- (void)MapPointsFromLine:(CCLine *)line      //called each time a line drawing event ends
{
    if (line) {
        self.lineForRoute = line;
    }   else
    {
        NSLog(@"bad line");
    }
    
}

- (void)updateButtons
{
    self.routeButton.enabled = YES;
}

#pragma mark - IBActions

- (IBAction)routeButtonPressed:(id)sender
{
    if (self.lineForRoute != nil) {
        [self.delegate updateMapWithLineForRoute:self.lineForRoute];  //sends points to delegate for route
        [self.drawView clearLines];
    }
}

- (IBAction)backToMapButtonPressed:(id)sender
{
    [self.delegate endDrawingWithNoLine];   //tells delegate there was no drawing event
    [self.drawView clearLines];

}

#pragma mark - Animations

- (void)easeButtonsIn
{
    [UIView animateWithDuration:0.4f animations:^{
        self.backToMapButton.alpha = 1.0f;
        self.routeButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)easeButtonsOut
{
    [UIView animateWithDuration:0.4f animations:^{
        self.backToMapButton.alpha = 0.0f;
        self.routeButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
    }];
}
@end
