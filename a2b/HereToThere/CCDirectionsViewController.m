//
//  CCDirectionsViewController.m
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "CCDirectionsViewController.h"
#import <MapKit/MapKit.h>

@interface CCDirectionsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *directionsCollectionView;
@property (strong, nonatomic) NSArray *stepsArray;
@property (strong, nonatomic) NSMutableArray *formattedDirectionsArray;

- (IBAction)doneButtonPressed:(id)sender;

@end

@implementation CCDirectionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeStepsFromRouteController:) name:@"routeStepsToDisplay"
                                               object:nil];
    [self mapViewSetUp];
    [self directionsCollectionViewSetUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)mapViewSetUp
{
    self.mapViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
    [self addChildViewController:self.mapViewVC];
    
    self.mapViewVC.view.frame = self.view.frame;
    [self.view addSubview:self.mapViewVC.view];
    [self.mapViewVC didMoveToParentViewController:self];
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self.mapViewVC performSelectorOnMainThread:@selector(closeDirectionsView:) withObject:nil waitUntilDone:NO];
}

- (void)directionsCollectionViewSetUp
{
    self.directionsCollectionView.delegate = self;
    self.directionsCollectionView.backgroundColor = [UIColor clearColor];
    
}

- (void)routeStepsFromRouteController:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"routeStepsToDisplay"]) {
        self.stepsArray = [[NSArray alloc] initWithObjects: [notification.userInfo objectForKey:@"routeInfo"], nil];
        [self processDirectionSteps:self.stepsArray[0]];
    }

    
}

- (void)processDirectionSteps:(NSArray *)arrayOfMKRouteSteps
{
    self.formattedDirectionsArray = [[NSMutableArray alloc] init];

    for (MKRouteStep *directionStep in arrayOfMKRouteSteps) {
        NSDictionary *individualStepDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithDouble:
                                                                                                directionStep.distance],
                                                  @"stepDistance",directionStep.instructions, @"stepInstructions", nil];
        [self.formattedDirectionsArray addObject:individualStepDictionary];
        self.directionsCollectionView.dataSource = self;
    }
    
}

#pragma mark - collection view data source methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.formattedDirectionsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"directionStepCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = [[UIColor colorWithRed:112.f/255 green:128.f/255 blue:144.f/255 alpha:1.0f] CGColor];
    cell.layer.borderWidth = 2.0;
    
    return cell;
}
@end
