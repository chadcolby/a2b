//
//  CCDirectionsCell.m
//  HereToThere
//
//  Created by Chad D Colby on 5/30/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "CCDirectionsCell.h"
#import <QuartzCore/QuartzCore.h>

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

    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0f);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {185.f/255, 61.f/255, 76.f/255, 1.0 };
    CGColorRef color = CGColorCreate(colorSpace, components);

    CGContextSetStrokeColorWithColor(context, color);

    CGContextMoveToPoint(context, self.bounds.size.width / 6, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - self.bounds.size.height);
    
    CGContextSetLineWidth(context, 2.0f);
    
    CGContextMoveToPoint(context, self.distanceLabel.bounds.size.width, self.distanceLabel.bounds.origin.y);
    CGContextAddLineToPoint(context, self.distanceLabel.bounds.size.width, self.unitsLabel.bounds.size.height);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(color);
    
}



@end
