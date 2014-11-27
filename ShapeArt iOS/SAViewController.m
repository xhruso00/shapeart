//
//  SAViewController.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAViewController.h"
#import "SADocumentView.h"
#import "SADocument.h"
#import "SAShape+Factory.h"
#import "SAColorSelectorViewController.h"
#import "SAShapeSelectorViewController.h"

@interface SAViewController ()

@property (weak) SAColorSelectorViewController *fillColorSelectorViewController;
@property (weak) SAColorSelectorViewController *strokeColorSelectorViewController;

@property (strong) SADocument *document;

@end

@implementation SAViewController {
  CGPoint dragStart;
  CGPoint shapeStartPosition;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"shapeSelectorSeque"]) {
    UINavigationController *navigationController = [segue destinationViewController];
    SAShapeSelectorViewController *shapeSelectorViewController = (SAShapeSelectorViewController *)[navigationController topViewController];
    shapeSelectorViewController.delegate = self;
    shapeSelectorViewController.currentShape = self.document.currenDocumentModel.currentShapeType;
  }
  else if ([[segue identifier] isEqualToString:@"strokeColorSelectorSeque"]) {
    UINavigationController *navigationController = [segue destinationViewController];
    SAColorSelectorViewController *strokeColorSelectorViewController = (SAColorSelectorViewController *)[navigationController topViewController];
    strokeColorSelectorViewController.delegate = self;
    strokeColorSelectorViewController.color = self.document.currenDocumentModel.currentStrokeColor;
    strokeColorSelectorViewController.strokeWidth = self.document.currenDocumentModel.currentStrokeWidth;
    strokeColorSelectorViewController.type = SAColorSelectorTypeStroke;
    self.strokeColorSelectorViewController = strokeColorSelectorViewController;
  }
  else if ([[segue identifier] isEqualToString:@"fillColorSelectorSeque"]) {
    UINavigationController *navigationController = [segue destinationViewController];
    SAColorSelectorViewController *fillColorSelectorViewController = (SAColorSelectorViewController *)[navigationController topViewController];
    fillColorSelectorViewController.delegate = self;
    fillColorSelectorViewController.color = self.document.currenDocumentModel.currentFillColor;
    fillColorSelectorViewController.type = SAColorSelectorTypeFill;
    self.fillColorSelectorViewController = fillColorSelectorViewController;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadDocument];
}

- (void)loadDocument
{
  if (self.document == nil) {
    self.document = [[SADocument alloc] initWithFileURL:[SADocument documentURL]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[SADocument documentURL] path];
    
    __weak typeof(self) weakSelf = self;
    void (^document)(BOOL) = ^(BOOL success) {
      if (success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.document.currenDocumentModel.documentDelegate = self.shapeDocumentView;
        strongSelf.document.currenDocumentModel.undoManager = [self undoManager];
        strongSelf.shapeDocumentView.delegate = self;
      } else {
        NSLog(@"Failed");
      }
    };
    if ([fileManager fileExistsAtPath:path])
    {
      [self.document openWithCompletionHandler:document];
    } else {
      [self.document saveToURL:[SADocument documentURL]
              forSaveOperation:UIDocumentSaveForCreating
             completionHandler:document];
    }
}
}

- (void)viewClickedAtLocation:(CGPoint)location
{
  SAShape *newShape = [SAShape shapeWithType:self.document.currenDocumentModel.currentShapeType];
  newShape.strokeWidth = self.document.currenDocumentModel.currentStrokeWidth;
  newShape.fillColor = self.document.currenDocumentModel.currentFillColor;
  newShape.strokeColor = self.document.currenDocumentModel.currentStrokeColor;
  [self addShape:newShape atLocation:location];
}

- (void)addShape:(SAShape *)shape atLocation:(CGPoint)location
{
  if (shape != nil) {
    [self.document.currenDocumentModel addShape:shape atLocation:location];
  }
}

- (void)removeShape:(SAShape *)shape atLocation:(CGPoint)location
{
  if (shape != nil) {
    [self.document.currenDocumentModel removeShape:shape];
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
  where.y = shapeStartPosition.y + where.y;
  
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

- (IBAction)clear:(id)sender
{
  NSArray *shapes = [self.document.currenDocumentModel.shapes copy];
  [[self undoManager] beginUndoGrouping];
  for (SAShape *shape in shapes) {
    [self.document.currenDocumentModel removeShape:shape];
  }
  [[self undoManager] endUndoGrouping];
}

- (void)colorPanelView:(SAColorSelectorViewController *)colorSelectorViewController
        didChangeColor:(UIColor *)color
{
  if (colorSelectorViewController == self.fillColorSelectorViewController) {
    self.document.currenDocumentModel.currentFillColor = self.fillColorSelectorViewController.color;
  } else if (colorSelectorViewController == self.strokeColorSelectorViewController) {
    self.document.currenDocumentModel.currentStrokeColor = self.strokeColorSelectorViewController.color;
  }
}

- (void)colorPanelView:(SAColorSelectorViewController *)colorSelectorViewController
  didChangeStrokeWidth:(CGFloat)width
{
  self.document.currenDocumentModel.currentStrokeWidth = width;
}

- (void)shapeSelectorViewController:(SAShapeSelectorViewController *)controller
                     didSelectShape:(SAShapeType)shapeType
{
  self.document.currenDocumentModel.currentShapeType = shapeType;
}

@end
