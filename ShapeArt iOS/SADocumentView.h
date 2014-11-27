//
//  SADocumentView.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SADocumentModel.h"
#import "SAShapeView.h"

@protocol SADocumentViewDelegate <NSObject>
- (void)viewClickedAtLocation:(CGPoint)location;
@end

@interface SADocumentView : UIView <SADocumentModelDelegate, SAShapeViewDelegate, NSCoding>

@property (nonatomic, weak) NSObject<SADocumentViewDelegate, SAShapeViewDelegate> *delegate;

@end
