//
//  SAColorPanelView.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAColorPanelView.h"


@interface SAColorPanelView()
@property (nonatomic, weak) IBOutlet NSBox *colorBox;
@property (nonatomic, weak) IBOutlet NSView *colorPanelView;
@property (nonatomic, assign) NSView *sharedColorPanelView;
@end

@implementation SAColorPanelView

- (instancetype)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self) {
    self.color = [NSColor blackColor];
    [NSColorPanel setPickerMode:NSCrayonModeColorPanel];
    [NSColorPanel setPickerMask:NSColorPanelCrayonModeMask];
    NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
    colorPanel.showsAlpha = YES;
  }
  return self;
}

- (void)refreshColorPanel
{
  [self removeColorPanelViewFromSuperview];

  NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
  [colorPanel setTarget:nil];
  [colorPanel setColor:self.color];
  [colorPanel setTarget:self];
  [colorPanel setAction:@selector(changeColor:)];
  self.colorBox.fillColor = self.color;
  
  self.sharedColorPanelView = [[NSColorPanel sharedColorPanel] contentView];
  [self.colorPanelView addSubview:self.sharedColorPanelView positioned:NSWindowBelow relativeTo:nil];
}

- (void)removeColorPanelViewFromSuperview
{
  NSView *viewToRemove = nil;
  NSArray *subviews = [self.colorPanelView subviews];
  for (id view in subviews) {
    if ([view isEqualTo:self.sharedColorPanelView]) {
      viewToRemove = view;
    }
  }
  [viewToRemove removeFromSuperview];
}



- (void)changeColor:(id)sender
{
  self.color = [[sender color] copy];
  self.colorBox.fillColor = self.color;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

  SEL didChangeColorSelector = @selector(colorPanelView:didChangeColor:);
  if ([self.delegate respondsToSelector:didChangeColorSelector]) {
    [self.delegate performSelector:didChangeColorSelector withObject:self withObject:self.color];
  }
  
#pragma clang diagnostic pop
}
//

@end
