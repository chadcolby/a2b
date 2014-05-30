//
//  CCMenuView.m
//  HereToThere
//
//  Created by Chad D Colby on 5/28/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "CCMenuView.h"

@interface CCMenuView ()

@end

@implementation CCMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8f;
        
        [self buttonsSetUp];

    }
    return self;
}

- (void)buttonsSetUp
{
    self.directionsButton = [[CCRoundButton alloc] initWithFrame:CGRectMake(self.bounds.origin.x + 15, 25, 50, 50)];
    [self.directionsButton setImage:[UIImage imageNamed:@"directions"] forState:UIControlStateNormal];
    self.directionsButton.enabled = NO;
    [self addSubview:self.directionsButton];
    
    self.forwardButton = [[CCRoundButton alloc] initWithFrame:CGRectMake(self.bounds.origin.x + 95, 25, 50, 50)];
    [self.forwardButton setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    [self addSubview:self.forwardButton];
    
    self.clearButton = [[CCRoundButton alloc] initWithFrame:CGRectMake(self.bounds.origin.x + 175, 25, 50, 50)];
    [self.clearButton setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    self.clearButton.enabled = NO;
    [self addSubview:self.clearButton];
    
    self.settingsButton = [[CCRoundButton alloc] initWithFrame:CGRectMake(self.bounds.origin.x + 255, 25, 50, 50)];
    [self.settingsButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [self addSubview:self.settingsButton];
}

/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
