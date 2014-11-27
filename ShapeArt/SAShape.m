//
//  SAShape.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAShape.h"
#import "SATriangleShape.h"
#import "SARectangleShape.h"
#import "SAEllipseShape.h"
#import "SADocumentModel.h"

NSString *kKeyFrame =         @"keyFrame";
NSString *kKeyPosition =      @"keyPosition";
NSString *kKeySize =          @"keySize";
NSString *kKeyStrokeWidht =   @"keyStrokeWidth";
NSString *kKeyShouldFill =    @"keyShouldFill";
NSString *kKeyShouldStroke =  @"keyShoulStroke";
NSString *kKeyFillColor =     @"keyFillColor";
NSString *kKeyStrokeColor =   @"keyStrokeColor";
NSString *kKeyModel =         @"keyModel";

NSString *kShapeChangedNotification = @"SAShapeChangedNotification";

@implementation SAShape

- (instancetype)init
{
  // We could check self's class here to prevent direct instantiation of abstract Shape objects.
  self = [super init];
  if (self) {
    self.position = CGPointMake(0, 0);
    self.size = CGSizeMake(50, 50);
    self.shouldFill = YES;
    self.shouldStroke = YES;
    self.fillColor =[XPlatformColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    self.strokeColor =[XPlatformColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.strokeWidth = 5;
  }
  return self;
}
  
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self) {
    CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)([aDecoder decodeObjectForKey:kKeyPosition]), &_position);
    CGSizeMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)([aDecoder decodeObjectForKey:kKeySize]), &_size);
    self.strokeWidth = [[aDecoder decodeObjectForKey:kKeyStrokeWidht] doubleValue];
    self.shouldFill = [[aDecoder decodeObjectForKey:kKeyShouldFill] boolValue];
    self.shouldStroke = [[aDecoder decodeObjectForKey:kKeyShouldStroke] boolValue];
    self.fillColor = [[aDecoder decodeObjectForKey:kKeyFillColor] XPlatformColor];
    self.strokeColor = [[aDecoder decodeObjectForKey:kKeyStrokeColor] XPlatformColor];
    self.model = [aDecoder decodeObjectForKey:kKeyModel];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:CFBridgingRelease(CGPointCreateDictionaryRepresentation(self.position)) forKey:kKeyPosition];
  [aCoder encodeObject:CFBridgingRelease(CGSizeCreateDictionaryRepresentation(self.size)) forKey:kKeySize];
  [aCoder encodeObject:@(self.strokeWidth) forKey:kKeyStrokeWidht];
  [aCoder encodeObject:@(self.shouldFill) forKey:kKeyShouldFill];
  [aCoder encodeObject:@(self.shouldStroke) forKey:kKeyShouldStroke];
  
  // We encode a CIColor because it will decode on both iOS and OS X. Not so with NSColor and UIColor
  [aCoder encodeObject:[self.fillColor CIColor] forKey:kKeyFillColor];
  [aCoder encodeObject:[self.strokeColor CIColor] forKey:kKeyStrokeColor];
  
  [aCoder encodeConditionalObject:self.model forKey:kKeyModel];
}

- (void)setupContextForDrawing:(CGContextRef)context
{
  
}

- (CGRect)paddedFrame
{
  CGFloat padding = 5.0f;
  return CGRectMake(self.position.x - self.size.width / 2 - padding,
                    self.position.y - self.size.height / 2 - padding,
                    self.size.width + 2 * padding,
                    self.size.height + 2 * padding);
}

- (void)setPosition:(CGPoint)position
{
  _position = position;
  [[NSNotificationCenter defaultCenter] postNotificationName:kShapeChangedNotification object:self];
}

- (CGPathRef)createDrawingPath
{
  // Live to be overriden.
  [NSException raise:NSInternalInconsistencyException format:@"-createDrawingPath hasn't been overridden."];
  return nil;
}

@end
