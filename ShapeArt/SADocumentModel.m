//
//  SADocumentModel.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SADocumentModel.h"
#import "SAShape.h"

NSString *kKeyShapes =              @"keyShapes";
NSString *kKeyCurrentFillColor =    @"keyCurrentFillColor";
NSString *kKeyCurrentStrokeColor =  @"keyCurrentStrokeColor";
NSString *kKeyCurrentShapeType =    @"keyCurrentShapeColor";
NSString *kKeyCurrentStrokeWidth =  @"keyCurrentStrokeWidth";

@implementation SADocumentModel

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.shapes = [NSMutableArray arrayWithCapacity:0];
    self.currentFillColor = [XPlatformColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    self.currentStrokeColor = [XPlatformColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.currentShapeType = SAShapeTypeRectangle;
    self.currentStrokeWidth = 5;
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self) {
    self.shapes = [[aDecoder decodeObjectForKey:kKeyShapes] mutableCopy];
    self.currentFillColor = [[aDecoder decodeObjectForKey:kKeyCurrentFillColor] XPlatformColor];
    self.currentStrokeColor = [[aDecoder decodeObjectForKey:kKeyCurrentStrokeColor] XPlatformColor];
    self.currentStrokeWidth = [aDecoder decodeFloatForKey:kKeyCurrentStrokeWidth];
    self.currentShapeType = [aDecoder decodeIntegerForKey:kKeyCurrentShapeType];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.shapes forKey:kKeyShapes];
  [aCoder encodeInteger:self.currentShapeType forKey:kKeyCurrentShapeType];
  [aCoder encodeObject:[self.currentFillColor CIColor] forKey:kKeyCurrentFillColor];
  [aCoder encodeObject:[self.currentStrokeColor CIColor] forKey:kKeyCurrentStrokeColor];
  [aCoder encodeFloat:self.currentStrokeWidth forKey:kKeyCurrentStrokeWidth];
}

- (void)addShape:(SAShape *)shape atLocation:(CGPoint)location
{
  NSLog(@"Shapes count: %lu", [self.shapes count]);
  shape.position = location;
  shape.strokeColor = self.currentStrokeColor;
  shape.fillColor = self.currentFillColor;
  shape.strokeWidth = self.currentStrokeWidth;
  shape.shouldFill = YES;
  shape.shouldStroke = YES;
  shape.model = self;
  
  [[self undoManager] registerUndoWithTarget:self selector:@selector(removeShape:) object:shape];
  
  [self.shapes addObject:shape];

  if ([self.documentDelegate respondsToSelector:@selector(shapeAdded:)]) {
    [self.documentDelegate shapeAdded:shape];
  }
}

- (void)removeShape:(SAShape *)shape
{
  [[[self undoManager] prepareWithInvocationTarget:self] addShape:shape atLocation:shape.position];
  [self.shapes removeObject:shape];
  if ([self.documentDelegate respondsToSelector:@selector(shapeRemoved:)]) {
    [self.documentDelegate shapeRemoved:shape];
  }
}

- (void)setDocumentDelegate:(NSObject<SADocumentModelDelegate> *)documentDelegate
{
  _documentDelegate = documentDelegate;
  for (SAShape *shape in self.shapes) {
    if ([self.documentDelegate respondsToSelector:@selector(shapeAdded:)]) {
      [self.documentDelegate shapeAdded:shape];
    }
  }
}

@end
