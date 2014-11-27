//
//  SAShapeView.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAShape;

@protocol SAShapeViewDelegate <NSObject>
- (void)didBeginDraggingShape:(SAShape *)shape fromLocation:(CGPoint)where;
- (void)didDragShape:(SAShape *)shape toLocation:(CGPoint)where;
- (void)didEndDraggingShape:(SAShape *)shape;
@end

@interface SAShapeView : UIView

@property (nonatomic, weak) NSObject<SAShapeViewDelegate> *delegate;
@property (nonatomic, retain) SAShape *shape;

- (instancetype)initWithShape:(SAShape *)aShape;

@end
