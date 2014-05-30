//
//  CCDrawView.m
//  HereToThere
//
//  Created by Chad D Colby on 5/29/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "CCDrawView.h"

@interface CCDrawView ()

@end

@implementation CCDrawView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.multipleTouchEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.completedLines = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - Drawing methods

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.f);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    [[UIColor colorWithRed:112.f/255 green:128.f/255 blue:144.f/255 alpha:1.f] set];
    for (CCLine *onScreenLine in self.completedLines) {
        CGContextMoveToPoint(context, onScreenLine.startPoint.x, onScreenLine.startPoint.y);
        CGContextAddLineToPoint(context, onScreenLine.endPoint.x, onScreenLine.endPoint.y);
        CGContextStrokePath(context);
    }
    
    [[UIColor colorWithRed:112.f/255 green:128.f/255 blue:144.f/255 alpha:0.75f] set];
    for (NSValue *value in self.linesInProgress) {
        CCLine *lineInProgress = [self.linesInProgress objectForKey:value];
        CGContextMoveToPoint(context, lineInProgress.startPoint.x, lineInProgress.startPoint.y);
        CGContextAddLineToPoint(context, lineInProgress.endPoint.x, lineInProgress.endPoint.y);
        CGContextStrokePath(context);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *finger in touches) {
        
        if (self.completedLines.count >= 1) {
            [self clearLines];
        }
        NSValue *key = [NSValue valueWithNonretainedObject:finger];
        CGPoint lock = [finger locationInView:self];
        CCLine *anotherLine = [[CCLine alloc] init];
        anotherLine.startPoint = lock;
        anotherLine.endPoint = lock;
        [self.linesInProgress setObject:anotherLine forKey:key];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        NSValue *touchKey = [NSValue valueWithNonretainedObject:touch];
        CCLine *movingLine = [self.linesInProgress objectForKey:touchKey];
        CGPoint lock = [touch locationInView:self];
        movingLine.endPoint = lock;
        [self.delegate updateButtons];
    }
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawingDidEnd:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawingDidEnd:touches];
}

- (void) clearLines
{
    [self.linesInProgress removeAllObjects];
    [self.completedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void) drawingDidEnd:(NSSet *)touches
{
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        CCLine *finishedLine = [self.linesInProgress objectForKey:key];
        if (finishedLine) {
            [self.completedLines addObject:finishedLine];
            [self.linesInProgress removeObjectForKey:key];
            [self.delegate MapPointsFromLine:finishedLine]; //updates controller with points without requesting mapPoints
        }
    }
    [self setNeedsDisplay];
}

@end
