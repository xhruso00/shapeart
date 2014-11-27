//
//  SAShapeView.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAShapeView.h"
#import "SAShape.h"

@implementation SAShapeView

- (instancetype)initWithShape:(SAShape *)aShape
{
  self = [super initWithFrame:[aShape paddedFrame]];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shapeChanged)
                                                 name:kShapeChangedNotification
                                               object:aShape];
    _shape = aShape;
    self.backgroundColor = [UIColor clearColor];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(moveShape:)];
    [self addGestureRecognizer:panRecognizer];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kShapeChangedNotification
                                                object:self.shape];
}

- (void)drawRect:(CGRect)dirtyRect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  if (context == NULL) return;
  
  CGContextSaveGState(context);
  CGPathRef path = [self.shape createDrawingPath];
  
  if ([self.shape shouldFill]) {
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [self.shape.fillColor CGColor]);
    CGContextFillPath(context);
  }
  
  if ([self.shape shouldStroke]) {
    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, [self.shape.strokeColor CGColor]);
    CGContextSetLineWidth(context, self.shape.strokeWidth);
    CGContextStrokePath(context);
  }
  
  CGPathRelease(path);
  CGContextRestoreGState(context);
}

- (void)shapeChanged
{
  self.frame = [self.shape paddedFrame];
}

- (void)moveShape:(UIPanGestureRecognizer *)sender
{
  CGPoint location = [sender locationInView:[self superview]];
  
  if ([sender state] == UIGestureRecognizerStateBegan) {
    if ([self.delegate respondsToSelector:@selector(didBeginDraggingShape:fromLocation:)]) {
      [self.delegate didBeginDraggingShape:self.shape fromLocation:location];
    }
  }
  else if ([sender state] == UIGestureRecognizerStateChanged) {
    if ([self.delegate respondsToSelector:@selector(didDragShape:toLocation:)]) {
      [self.delegate didDragShape:self.shape toLocation:location];
    }
  }
  else if ([sender state] == UIGestureRecognizerStateEnded) {
    if ([self.delegate respondsToSelector:@selector(didEndDraggingShape:)]) {
      [self.delegate didEndDraggingShape:self.shape];
    }
  }
  

}

@end
