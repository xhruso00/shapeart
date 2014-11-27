//
//  SADocumentView.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SADocumentView.h"
#import "SAShapeView.h"
#import "SAShape.h"

@implementation SADocumentView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
  }
  return self;
}
- (void)shapeAdded:(SAShape *)shape
{
  SAShapeView *aShapeView = [[SAShapeView alloc] initWithShape:shape];
  [aShapeView setDelegate:self];
  [self addSubview:aShapeView];
}

- (void)shapeRemoved:(SAShape *)shape
{
  UIView *viewToRemove = nil;
  NSArray *subviews = [self subviews];
  for (SAShapeView *aShapeView in subviews) {
    if ([aShapeView.shape isEqual:shape]) {
      viewToRemove = aShapeView;
    }
  }
  [(SAShapeView *)viewToRemove setDelegate:nil];
  [viewToRemove removeFromSuperview];
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

- (IBAction)handleTap:(id)sender
{
  CGPoint location = [sender locationInView:self];
  if ([self.delegate respondsToSelector:@selector(viewClickedAtLocation:)]) {
    [self.delegate viewClickedAtLocation:location];
  }
}

@end
