//
//  SADocumentView.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SADocumentView.h"
#import "SAShapeView.h"
#import "SAShape.h"

@implementation SADocumentView

- (id)initWithFrame:(NSRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
      [self commonInit];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  
}

- (void)shapeAdded:(SAShape *)shape
{
  SAShapeView *aShapeView = [[SAShapeView alloc] initWithShape:shape];
  [aShapeView setDelegate:self];
  [self addSubview:aShapeView positioned:NSWindowBelow relativeTo:nil];
}

- (void)shapeRemoved:(SAShape *)shape
{
  NSView *viewToRemove = nil;
  NSArray *subviews = [self subviews];
  for (SAShapeView *aShapeView in subviews) {
    if ([aShapeView.shape isEqualTo:shape]) {
      viewToRemove = aShapeView;
    }
  }
  [(SAShapeView *)viewToRemove setDelegate:nil];
  [viewToRemove removeFromSuperview];
}

- (BOOL)isFlipped
{
  return YES;
}

- (void)commonInit
{
  [self setWantsLayer:YES];
}

- (BOOL)wantsUpdateLayer
{
  return YES;
}

- (void)updateLayer
{
  self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
}

- (void)mouseDown:(NSEvent *)event
{
  CGPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
  if ([self.delegate respondsToSelector:@selector(viewClickedAtLocation:)]) {
    [self.delegate viewClickedAtLocation:location];
  }
}

- (void)didBeginDraggingShape:(SAShape *)shape fromLocation:(CGPoint)where
{
  if ([self.delegate respondsToSelector:@selector(didBeginDraggingShape:fromLocation:)]) {
    [self.delegate didBeginDraggingShape:shape fromLocation:where];
  }
}
- (void)didDragShape:(SAShape *)shape toLocation:(CGPoint)where
{
  if ([self.delegate respondsToSelector:@selector(didDragShape:toLocation:)]) {
    [self.delegate didDragShape:shape toLocation:where];
  }
}

- (void)didEndDraggingShape:(SAShape *)shape
{
  if ([self.delegate respondsToSelector:@selector(didEndDraggingShape:)]) {
    [self.delegate didEndDraggingShape:shape];
  }
}

- (void)clearDocumentView
{
  [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
