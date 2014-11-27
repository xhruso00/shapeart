//
//  SADocument.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 26/08/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SADocument.h"
#import "XPlatformColor.h"
#import "SAShape+Factory.h"
#import "SAColorPanelView.h"

@interface SADocument() <NSPopoverDelegate>

@property (weak, nonatomic) IBOutlet NSSegmentedControl *toolSegmentedControl;

@property (strong) IBOutlet NSPopover *toolbarPopover;
@property (strong) IBOutlet NSViewController *fillColorViewController;
@property (strong) IBOutlet NSViewController *strokeInfoViewController;

@property (weak) IBOutlet SAColorPanelView *fillColorPanel;
@property (weak) IBOutlet SAColorPanelView *strokeColorPanel;

@property (weak) IBOutlet NSButton *strokeButton;
@property (weak) IBOutlet NSButton *fillButton;

@property (weak) IBOutlet NSSlider *strokeWidthSlider;
@property (weak) IBOutlet NSTextField *strokeWidthLabel;

@property (strong) SADocumentModel *currenDocumentModel;

@end

@implementation SADocument {
  CGPoint dragStart;
  CGPoint shapeStartPosition;
}

- (id)init
{
    self = [super init];
    if (self) {
    // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
  // Override returning the nib file name of the document
  // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
  return @"SADocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
  [super windowControllerDidLoadNib:aController];
  // Add any code here that needs to be executed once the windowController has loaded the document's window.
  
  if (self.currenDocumentModel == nil) {
    self.currenDocumentModel = [[SADocumentModel alloc] init];
  }
  self.currenDocumentModel.documentDelegate = self.shapeDocumentView;
  self.currenDocumentModel.undoManager = [self undoManager];
  self.shapeDocumentView.delegate = self;
  self.fillColorPanel.delegate = self;
  self.strokeColorPanel.delegate = self;
  [self.toolSegmentedControl.cell selectSegmentWithTag:self.currenDocumentModel.currentShapeType];
  
  [self.strokeWidthSlider setAction:@selector(updateStrokeWidth:)];
  [self.strokeWidthSlider setTarget:self];
}

- (void)colorPanelView:(SAColorPanelView *)colorPanelView didChangeColor:(NSColor *)color
{
  if (colorPanelView == self.fillColorPanel) {
    self.currenDocumentModel.currentFillColor = self.fillColorPanel.color;
  } else if (colorPanelView == self.strokeColorPanel) {
    self.currenDocumentModel.currentStrokeColor = self.strokeColorPanel.color;
  }
}

- (void)viewClickedAtLocation:(CGPoint)location
{
  SAShape *newShape = [SAShape shapeWithType:self.currenDocumentModel.currentShapeType];
  newShape.strokeWidth = self.currenDocumentModel.currentStrokeWidth;
  newShape.fillColor = self.currenDocumentModel.currentFillColor;
  newShape.strokeColor = self.currenDocumentModel.currentStrokeColor;
  [self addShape:newShape atLocation:location];
}

- (void)addShape:(SAShape *)shape atLocation:(CGPoint)location
{
  if (shape != nil) {
    [self.currenDocumentModel addShape:shape atLocation:location];
  }
}

- (void)removeShape:(SAShape *)shape atLocation:(CGPoint)location
{
  if (shape != nil) {
    [self.currenDocumentModel removeShape:shape];
  }
}

// ShapeViewDelegate
- (void)didBeginDraggingShape:(SAShape *)shape fromLocation:(CGPoint)where
{
  // Save the initial mousedown location and shape position.
  // As we drag, we will calculate each drag step as an absolute offset from the start
  // This allows us to avoid drift we would see if we simply followed the x/y deltas in the events.
  // Warning: we assume here that anothe didBeginDraggingShape: will not be received until
  // the current drag is complete. but it'd be wise to check/enforce this.
  dragStart = where;
  shapeStartPosition = [shape position];
  
  [[self undoManager] disableUndoRegistration];
}


- (void)didDragShape:(SAShape *)shape toLocation:(CGPoint)where
{
  CGPoint oldPosition = [shape position];
  where.x -= dragStart.x;
  where.y -= dragStart.y;
  where.x += shapeStartPosition.x;
  where.y = shapeStartPosition.y - where.y;
  
  if (!CGPointEqualToPoint(where, oldPosition)) {
    [shape setPosition:where];
  }
}

- (void)didEndDraggingShape:(SAShape *)shape
{
  [[self undoManager] enableUndoRegistration];
  
  // Wait until the end of the drag to configure the undo manager so that it's treated as a single operation.
  [[[self undoManager] prepareWithInvocationTarget:shape] setPosition:shapeStartPosition];
}

#pragma mark -

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.currenDocumentModel];
  return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  self.currenDocumentModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  [self.shapeDocumentView clearDocumentView];
  self.currenDocumentModel.documentDelegate = self.shapeDocumentView;
  self.currenDocumentModel.undoManager = [self undoManager];
  return YES;
}

#pragma mark -

- (IBAction)toolSelected:(NSSegmentedControl *)sender
{
  self.currenDocumentModel.currentShapeType = [sender selectedSegment];
}

- (IBAction)showStrokeColorPanel:(id)sender
{
  self.strokeColorPanel.color = self.currenDocumentModel.currentStrokeColor;
  [self.toolbarPopover setContentViewController:self.strokeInfoViewController];
  [self.toolbarPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
}

- (IBAction)showFillColorPanel:(id)sender
{
  self.fillColorPanel.color = self.currenDocumentModel.currentFillColor;
  [self.toolbarPopover setContentViewController:self.fillColorViewController];
  [self.toolbarPopover showRelativeToRect:[self.fillButton bounds] ofView:self.fillButton preferredEdge:NSMinXEdge];
}

- (void)popoverWillShow:(NSNotification *)notification
{
  [(SAColorPanelView *)[self.toolbarPopover.contentViewController view] refreshColorPanel];
}

- (IBAction)updateStrokeWidth:(id)sender
{
  self.currenDocumentModel.currentStrokeWidth = [sender floatValue];
  self.strokeWidthLabel.stringValue = [NSString stringWithFormat:@"%.1f",[sender floatValue]];
}

//- (BOOL)revertToContentsOfURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
//{
//  BOOL revertSuccess =  [super revertToContentsOfURL:url ofType:typeName error:outError];
//  self.currenDocumentModel.documentDelegate = self.shapeDocumentView;
//  return revertSuccess;
//}

@end
