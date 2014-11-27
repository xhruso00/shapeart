//
//  SAShapeSelectorViewController.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAShape.h"

@protocol SAShapeSelectorViewControllerDelegate;

@interface SAShapeSelectorViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak) id<SAShapeSelectorViewControllerDelegate> delegate;
@property SAShapeType currentShape;
@end

@protocol SAShapeSelectorViewControllerDelegate <NSObject>
- (void)shapeSelectorViewController:(SAShapeSelectorViewController *)controller
                     didSelectShape:(SAShapeType)shapeType;


@end
