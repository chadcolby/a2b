//
//  CCDirectionsViewController.m
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "CCDirectionsViewController.h"
#import "CCDirectionsCell.h"
#import <MapKit/MapKit.h>

@interface CCDirectionsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *directionsCollectionView;
@property (strong, nonatomic) NSArray *stepsArray;
@property (strong, nonatomic) NSMutableArray *formattedDirectionsArray;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeToDeleteRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressToSelect;
@property (strong, nonatomic) UITapGestureRecognizer *tapToDismissDelete;

- (IBAction)doneButtonPressed:(id)sender;

@end

@implementation CCDirectionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeStepsFromRouteController:) name:@"routeStepsToDisplay" object:nil];
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

- (IBAction)doneButtonPressed:(id)sender //forces mapView to re-size itself and become active
{
    [self.mapViewVC performSelectorOnMainThread:@selector(closeDirectionsView:) withObject:nil waitUntilDone:NO];
    [self.directionsCollectionView scrollToItemAtIndexPath:nil atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

- (void)directionsCollectionViewSetUp
{
    self.directionsCollectionView.delegate = self;
    self.directionsCollectionView.backgroundColor = [UIColor clearColor];
    
    self.swipeToDeleteRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    self.swipeToDeleteRecognizer.numberOfTouchesRequired = 1;
    self.swipeToDeleteRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.swipeToDeleteRecognizer.delegate = self;
    [self.directionsCollectionView addGestureRecognizer:self.swipeToDeleteRecognizer];
    
    self.longPressToSelect = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    self.longPressToSelect.numberOfTouchesRequired = 1;
    self.longPressToSelect.allowableMovement = 10.0f;
    self.longPressToSelect.minimumPressDuration = 0.5f;
    [self.directionsCollectionView addGestureRecognizer:self.longPressToSelect];
    
    self.tapToDismissDelete = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissArrow:)];
    self.tapToDismissDelete.numberOfTapsRequired = 2;
    self.tapToDismissDelete.numberOfTouchesRequired = 1;
    [self.directionsCollectionView addGestureRecognizer:self.tapToDismissDelete];

}

- (void)routeStepsFromRouteController:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"routeStepsToDisplay"]) {
        self.stepsArray = [[NSArray alloc] initWithObjects: [notification.userInfo objectForKey:@"routeInfo"], nil];
        [self processDirectionSteps:self.stepsArray[0]];
        [self.directionsCollectionView reloadData];
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
    CCDirectionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"directionStepCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (cell.arrowImageView.alpha != 0.0) {
        [cell dismissDeleteArrow];
    }

    NSNumber *distanceHolderNumber = [[self.formattedDirectionsArray objectAtIndex:indexPath.item]
                                      objectForKey:@"stepDistance"];
    cell.distanceLabel.text = [[self convertDistance:distanceHolderNumber] objectAtIndex:0];
    cell.unitsLabel.text = [[self convertDistance:distanceHolderNumber] objectAtIndex:1];
    cell.instructionsLabel.text = [[self.formattedDirectionsArray objectAtIndex:indexPath.row]
                                   objectForKey:@"stepInstructions"];

    return cell;
}

- (NSArray *)convertDistance:(NSNumber *)metersToConvert
{
    NSString *convertedString;
    NSString *unitsString;
    
    if ([metersToConvert doubleValue] == 0.0) {
        convertedString = @"start";
        unitsString = @"route";
    } else if ([metersToConvert doubleValue] <= 201.17) {
        CGFloat feetFloat = ([metersToConvert floatValue] * 3.28084);
        convertedString = [NSString stringWithFormat:@"%.0f", feetFloat];
        unitsString = @"feet";
    } else if ([metersToConvert doubleValue] <= 402.33) {
        convertedString = @"1/4";   //quarter mile
        unitsString = @"mile";
    } else if ([metersToConvert doubleValue] <= 531.09) {
        convertedString = @"1/3";
        unitsString = @"mile";
    } else if ([metersToConvert doubleValue] <= 804.67) {
        convertedString = @"1/2";
        unitsString = @"mile";
    } else if ([metersToConvert doubleValue] <= 1062.62) {
        convertedString = @"2/3";
        unitsString = @"mile";
    } else if ([metersToConvert doubleValue] <= 1207.01) {
        convertedString = @"3/4";
        unitsString = @"mile";
    }  else if ([metersToConvert doubleValue] <= 1408.18) {
        convertedString = @"7/8";
        unitsString = @"mile";
    } else {
        CGFloat mileHolder = ([metersToConvert floatValue] * 0.000621371);
        convertedString = [NSString stringWithFormat:@"%.2f", mileHolder];
        unitsString = @"miles";
    }
    
    NSArray *convertedDistanceAndUnitsArray = [NSArray arrayWithObjects:convertedString, unitsString, nil];
    return convertedDistanceAndUnitsArray;
}

#pragma mark - gesture recognizers

- (void)swipeDetected:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"detecting");
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"swiping");
    }
}

- (void)longPressDetected:(UILongPressGestureRecognizer *)sender
{
    NSInteger pressedRow;
    NSIndexPath *pressedIndexpath = [self.directionsCollectionView indexPathForItemAtPoint:[sender locationInView:self.directionsCollectionView]];
    if (sender.state == UIGestureRecognizerStateBegan) {
        pressedRow = pressedIndexpath.item;
        NSLog(@"we gots the long press at %ld", (long)pressedRow);
        [self animateSelectedCell:(CCDirectionsCell *)[self.directionsCollectionView cellForItemAtIndexPath:pressedIndexpath]];
    }
    
}

- (void)tapToDismissArrow:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized) {
        CCDirectionsCell *activeCell = (CCDirectionsCell *)[self.directionsCollectionView cellForItemAtIndexPath:[self.directionsCollectionView indexPathForItemAtPoint:[sender locationInView:self.directionsCollectionView]]];
        if (activeCell.arrowImageView.alpha != 0.0) {
            [activeCell dismissDeleteArrow];
        }
    }
}

- (void)animateSelectedCell:(CCDirectionsCell *)selectedCell;
{
    [selectedCell addArrowViewForDeleteLongPress]; //animates the addition of the arrow view to indicate selection
}

#pragma mark - collection view delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
