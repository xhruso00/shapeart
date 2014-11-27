//
//  ShapeSelectorViewController.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAShapeSelectorViewController.h"

@interface SAShapeSelectorViewController ()
@property (weak) UITableView *tableView;
@property (strong) NSArray *shapeTypes;
@end

@implementation SAShapeSelectorViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.shapeTypes = @[@"Rectangle", @"Ellipse", @"Triangle"];
  [self.tableView reloadData];
}

- (IBAction)done:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentShape inSection:0];
  
  if (indexPath.row == oldIndexPath.row) {
    return;
  }
  
  
  UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
  if (newCell.accessoryType == UITableViewCellAccessoryNone) {
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.currentShape = indexPath.row;
  }
  
  UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
  if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
    oldCell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  [self.delegate shapeSelectorViewController:self didSelectShape:self.currentShape];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.shapeTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"tableViewShapeCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  NSString *shapeType = [self.shapeTypes objectAtIndex:indexPath.row];
  if (indexPath.row == self.currentShape) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  cell.textLabel.text = shapeType;
  return cell;
}

@end
