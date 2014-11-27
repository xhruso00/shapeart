//
//  SADocument.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SADocumentModel.h"
#import "SAShapeView.h"
#import "SADocumentView.h"

@interface SADocument : NSDocument <SAShapeViewDelegate, SADocumentViewDelegate>

@property (weak) IBOutlet SADocumentView *shapeDocumentView;

@end
