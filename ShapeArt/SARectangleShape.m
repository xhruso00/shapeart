//
//  SARectangleShape.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SARectangleShape.h"

@implementation SARectangleShape

- (CGPathRef)createDrawingPath
{
  CGRect paddedFrame = [self paddedFrame];
  CGRect centeredFrame = CGRectMake((paddedFrame.size.width - self.size.width) / 2,
                                    (paddedFrame.size.height - self.size.height) / 2,
                                    self.size.width,
                                    self.size.height);
  return CGPathCreateWithRect(centeredFrame, NULL);
}


@end
