//
//  SAShape.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPlatformColor.h"

typedef NS_ENUM(NSUInteger, SAShapeType) {
  SAShapeTypeRectangle,
  SAShapeTypeEllipse,
  SAShapeTypeTriangle
};

extern NSString *kShapeChangedNotification;

@class SAShape, SADocumentModel;

@interface SAShape : NSObject <NSCoding>

@property (nonatomic, weak) SADocumentModel *model;

// Geometry
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) BOOL shouldFill;
@property (nonatomic, assign) BOOL shouldStroke;

// Colors
@property (nonatomic, strong) XPlatformColor *fillColor;
@property (nonatomic, strong) XPlatformColor *strokeColor;

// Call this from your drawInContext, unless you specifically need to change the meaning of strokeWidth, strokeColor etc.
- (void)setupContextForDrawing:(CGContextRef)context;

- (CGRect)paddedFrame;
- (CGPathRef)createDrawingPath;

@end
