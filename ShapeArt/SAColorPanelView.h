//
//  SAColorPanelView.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SAColorPanelView : NSView 

@property (weak) id delegate;
@property (strong) NSColor *color;

- (void)refreshColorPanel;
@end
