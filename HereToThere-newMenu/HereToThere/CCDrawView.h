//
//  CCDrawView.h
//  HereToThere
//
//  Created by Chad D Colby on 5/29/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLine.h"

@protocol MapPointsFromDrawnLine <NSObject>

- (void)MapPointsFromLine:(CCLine *)line;
- (void)updateButtons;

@end

@interface CCDrawView : UIView

@property (unsafe_unretained) id <MapPointsFromDrawnLine> delegate;

@property (strong, nonatomic) NSMutableArray *completedLines;
@property (strong, nonatomic) NSMutableDictionary *linesInProgress;

- (void) clearLines;
- (void) drawingDidEnd:(NSSet *)touches;

@end
