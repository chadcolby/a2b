//
//  CCDirectionsCell.m
//  HereToThere
//
//  Created by Chad D Colby on 5/30/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "CCDirectionsCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CCDirectionsCell ()

@end

@implementation CCDirectionsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIColor *colorForText = [UIColor colorWithRed:112.f/255 green:128.f/255 blue:144.f/255 alpha:1.0f];
        self.unitsLabel.textColor = colorForText;
        self.distanceLabel.textColor = colorForText;
        self.instructionsLabel.textColor = colorForText;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0f);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {185.f/255, 61.f/255, 76.f/255, 1.0 };
    CGColorRef color = CGColorCreate(colorSpace, components);

    CGContextSetStrokeColorWithColor(context, color);

    CGContextMoveToPoint(context, self.bounds.origin.x + 5, self.bounds.size.height - 1);
    CGContextAddLineToPoint(context, self.bounds.size.width -1, self.bounds.size.height - 1);
    CGContextAddLineToPoint(context, self.bounds.size.width - 1, self.bounds.size.height - (self.bounds.size.height - 1));
    
    CGContextMoveToPoint(context, self.distanceLabel.bounds.size.width + 1, self.distanceLabel.center.y - 8);
    CGContextAddLineToPoint(context, self.distanceLabel.bounds.size.width + 1, self.distanceLabel.center.y + 28);
    
    CGContextStrokePath(context);
    
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(color);

    
}

@end
