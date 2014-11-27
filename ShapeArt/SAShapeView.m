
//  SAShapeView.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAShapeView.h"
#import "SAShape.h"

@implementation SAShapeView

- (id)initWithShape:(SAShape *)aShape
{
  self = [super initWithFrame:NSRectFromCGRect([aShape paddedFrame])];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shapeChanged)
                                                 name:kShapeChangedNotification
                                               object:aShape];
    _shape = aShape;
    [self setWantsLayer:YES];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kShapeChangedNotification
                                                object:self.shape];
}

- (BOOL)wantsUpdateLayer
{
  return YES;
}

- (void)updateLayer
{
  self.layer.contents = CFBridgingRelease([self createBackingCGImage]);
}

- (void)drawRect:(NSRect)dirtyRect
{
  CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
  
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

- (CGImageRef)createBackingCGImage
{
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL,
                                               [self.shape paddedFrame].size.width,
                                               [self.shape paddedFrame].size.height,
                                               8,
                                               0,
                                               colorSpace,
                                               (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
  CGColorSpaceRelease(colorSpace);
  if (!context) return nil;
  
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
  
  CGContextRestoreGState(context);
  
  CGPathRelease(path);
  return CGBitmapContextCreateImage(context);
}

- (void)shapeChanged
{
  self.frame = [self.shape paddedFrame];
}

- (void)mouseDown:(NSEvent *)theEvent
{
  CGPoint location = [theEvent locationInWindow];
  if ([self.delegate respondsToSelector:@selector(didBeginDraggingShape:fromLocation:)]) {
    [self.delegate didBeginDraggingShape:self.shape fromLocation:location];
  }
}

- (void)mouseUp:(NSEvent *)theEvent
{
  if ([self.delegate respondsToSelector:@selector(didEndDraggingShape:)]) {
    [self.delegate didEndDraggingShape:self.shape];
  }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
  CGPoint location = [theEvent locationInWindow];
  if ([self.delegate respondsToSelector:@selector(didDragShape:toLocation:)]) {
    [self.delegate didDragShape:self.shape toLocation:location];
  }
}

- (void)mouseExited:(NSEvent *)theEvent
{
  if ([self.delegate respondsToSelector:@selector(didEndDraggingShape:)]) {
    [self.delegate didEndDraggingShape:self.shape];
  }
}

- (BOOL)isFlipped
{
  return YES;
}

@end
