//
//  SAColorSelectorViewController.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

typedef NS_ENUM(NSUInteger, SAColorSelectorType) {
  SAColorSelectorTypeStroke,
  SAColorSelectorTypeFill
};

@protocol SAColorSelectorViewControllerDelegate;

@interface SAColorSelectorViewController : UIViewController

@property (strong) UIColor *color;
@property SAColorSelectorType type;
@property CGFloat strokeWidth;
@property (weak) id<SAColorSelectorViewControllerDelegate> delegate;

@end

@protocol SAColorSelectorViewControllerDelegate <NSObject>

- (void)colorPanelView:(SAColorSelectorViewController *)colorPanelView didChangeColor:(UIColor *)color;
- (void)colorPanelView:(SAColorSelectorViewController *)colorPanelView didChangeStrokeWidth:(CGFloat)width;

@end