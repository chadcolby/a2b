//
//  CCDrawingViewController.h
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCRoundButton.h"
#import "CCLine.h"
#import "CCDrawView.h"

@protocol DrawingVCDelegate <NSObject>

- (void)endDrawingWithNoLine;
- (void)updateMapWithLineForRoute:(CCLine *)finishedLine;

@end

@interface CCDrawingViewController : UIViewController

@property (unsafe_unretained) id <DrawingVCDelegate> delegate;

@property (strong, nonatomic) CCDrawView *drawView;

@end
