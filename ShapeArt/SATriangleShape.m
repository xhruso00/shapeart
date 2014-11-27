//
//  SATriangleShape.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SATriangleShape.h"

@implementation SATriangleShape

- (CGPathRef)createDrawingPath
{
  CGMutablePathRef mutablePath = CGPathCreateMutable();
  CGRect paddedFrame = [self paddedFrame];
  CGRect centeredFrame = CGRectMake((paddedFrame.size.width - self.size.width) / 2,
                                    (paddedFrame.size.height - self.size.height) / 2,
                                    self.size.width,
                                    self.size.height);
  CGPathMoveToPoint(mutablePath, NULL, CGRectGetMinX(centeredFrame), CGRectGetMaxY(centeredFrame));
  CGPathAddLineToPoint(mutablePath, NULL,
                       CGRectGetMaxX(centeredFrame),
                       CGRectGetMaxY(centeredFrame));
  CGPathAddLineToPoint(mutablePath, NULL,
                       CGRectGetMidX(centeredFrame),
                       CGRectGetMinY(centeredFrame));
  CGPathCloseSubpath(mutablePath);
  CGPathRef triangle = CGPathCreateCopy(mutablePath);
  CGPathRelease(mutablePath);
  return triangle;
}

@end
