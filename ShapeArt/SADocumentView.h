//
//  SADocumentView.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SADocumentModel.h"
#import "SAShapeView.h"

@protocol SADocumentViewDelegate <NSObject>
- (void)viewClickedAtLocation:(CGPoint)location;
@end

@interface SADocumentView : NSView <SADocumentModelDelegate, SAShapeViewDelegate, NSCoding>

@property (nonatomic, weak) NSObject<SADocumentViewDelegate, SAShapeViewDelegate> *delegate;

- (void)clearDocumentView;

@end
