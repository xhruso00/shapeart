//
//  SAShape+Factory.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAShape.h"

@interface SAShape (Factory)

+ (instancetype)shapeWithType:(SAShapeType)aType;

@end
