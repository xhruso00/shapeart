//
//  SAViewController.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAShapeSelectorViewController.h"
#import "SAColorSelectorViewController.h"
#import "SADocumentView.h"

@interface SAViewController : UIViewController <SAShapeSelectorViewControllerDelegate, SAColorSelectorViewControllerDelegate, SADocumentViewDelegate, SAShapeViewDelegate>

@property (nonatomic, weak) NSObject<SADocumentViewDelegate>*delegate;
@property IBOutlet SADocumentView *shapeDocumentView;

@end
