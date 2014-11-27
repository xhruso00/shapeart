//
//  XPlatformColor.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_MAC && !TARGET_OS_IPHONE

//On Mac OS XPlatformColor is NSColor
#define XPlatformColor NSColor

#elif TARGET_OS_IPHONE

//On iOS OS XPlatformColor is UIColor
#define XPlatformColor UIColor

#endif

@interface XPlatformColor (XPlatformColor)
- (CIColor *)CIColor;
- (CGFloat)alpha;
@end


@interface CIColor (XPlatformColor)
- (XPlatformColor *)XPlatformColor;
@end