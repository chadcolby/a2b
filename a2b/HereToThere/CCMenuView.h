//
//  CCMenuView.h
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCRoundButton.h"

@interface CCMenuView : UIView

@property (strong, nonatomic) CCRoundButton *directionsButton;
@property (strong, nonatomic) CCRoundButton *forwardButton;
@property (strong, nonatomic) CCRoundButton *clearButton;
@property (strong, nonatomic) CCRoundButton *settingsButton;

@end
