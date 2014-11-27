//
//  SADocument.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SADocumentModel.h"
#import "SAShapeView.h"
#import "SADocumentView.h"

@interface SADocument : UIDocument

@property (strong, readonly) SADocumentModel *currenDocumentModel;

+ (NSURL *)documentURL;

@end
