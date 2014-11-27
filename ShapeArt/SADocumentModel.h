//
//  SADocumentModel.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPlatformColor.h"
#import "SAShape.h"

@protocol SADocumentModelDelegate <NSObject>
- (void)shapeAdded:(SAShape *)shape;
- (void)shapeRemoved:(SAShape *)shape;
@end

@interface SADocumentModel : NSObject <NSCoding>

@property (weak, nonatomic) NSObject<SADocumentModelDelegate> *documentDelegate;
@property (strong, nonatomic) NSUndoManager *undoManager;
@property (strong, nonatomic) NSMutableArray *shapes;
@property (strong, nonatomic) XPlatformColor *currentFillColor;
@property (strong, nonatomic) XPlatformColor *currentStrokeColor;
@property (assign, nonatomic) SAShapeType currentShapeType;
@property (assign, nonatomic) CGFloat currentStrokeWidth;

- (void)addShape:(SAShape *)shape atLocation:(CGPoint)location;
- (void)removeShape:(SAShape *)shape;

@end
