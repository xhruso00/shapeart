//
//  XPlatformColor.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "XPlatformColor.h"

@implementation XPlatformColor (XPlatformColor)

- (CIColor *)CIColor
{
  CIColor *color = [[CIColor alloc] initWithColor:self];
  return color;
}

- (CGFloat)alpha
{
  return CGColorGetAlpha([self CGColor]);
}

@end


@implementation CIColor (XPlatformColor)

- (XPlatformColor *)XPlatformColor
{
  XPlatformColor *color = [XPlatformColor colorWithCIColor:self];
  return color;
}

@end
