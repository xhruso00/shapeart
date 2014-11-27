//
//  SAShape+Factory.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAShape+Factory.h"
#import "SAEllipseShape.h"
#import "SARectangleShape.h"
#import "SATriangleShape.h"

@implementation SAShape (Factory)

+ (instancetype)shapeWithType:(SAShapeType)aType
{
  SAShape *shape;
  switch (aType) {
    case SAShapeTypeEllipse:
      shape = [[SAEllipseShape alloc] init];
      break;
    case SAShapeTypeRectangle:
      shape = [[SARectangleShape alloc] init];
      break;
    case SAShapeTypeTriangle:
      shape = [[SATriangleShape alloc] init];
    default:
      break;
  }
  return shape;
}

@end
