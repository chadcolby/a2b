//
//  CCDirectionsCell.h
//  HereToThere
//
//  Created by Chad D Colby on 5/30/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DirectionsCell;

@interface CCDirectionsCell : UICollectionViewCell 

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;

@end