//
//  SAShapeView.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SAShape;

@protocol SAShapeViewDelegate <NSObject>
- (void)didBeginDraggingShape:(SAShape *)shape fromLocation:(CGPoint)where;
- (void)didDragShape:(SAShape *)shape toLocation:(CGPoint)where;
- (void)didEndDraggingShape:(SAShape *)shape;
@end

@interface SAShapeView : NSView

@property (nonatomic, weak) NSObject<SAShapeViewDelegate> *delegate;
@property (nonatomic, retain) SAShape *shape;

- (instancetype)initWithShape:(SAShape *)aShape;

@end
