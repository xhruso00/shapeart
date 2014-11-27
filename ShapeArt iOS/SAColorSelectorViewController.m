//
//  SAColorSelectorViewController.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SAColorSelectorViewController.h"
#import "SAColorTableViewCell.h"

static NSString *cellIdentifier = @"colorTableViewCell";

@interface SAColorSelectorViewController ()
@property (weak) IBOutlet UITableView *tableView;
@property (weak) IBOutlet UISlider *slider;
@property (weak) IBOutlet UILabel *sliderValueLabel;
@end

@implementation SAColorSelectorViewController {
  NSUInteger selectedIndex;
}

- (NSArray *)colorNames
{
  static NSArray *colorNames;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    colorNames =  @[@"Licorice", @"Snow", @"Maraschino", @"Lemon", @"Flora", @"Blueberry", @"Plum"];
  });
  return colorNames;
}

- (NSDictionary *)colors
{
  static NSDictionary *colors;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    colors = @{
               [self colorNames][0] : [UIColor blackColor],
               [self colorNames][1] : [UIColor whiteColor],
               [self colorNames][2] : [UIColor redColor],
               [self colorNames][3] : [UIColor yellowColor],
               [self colorNames][4] : [UIColor colorWithRed:102/255 green:1.0f blue:102/255 alpha:1.0f],
               [self colorNames][5] : [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f],
               [self colorNames][6] : [UIColor colorWithRed:0.502 green:0.0f blue:0.502 alpha:1.0f]
               };
  });
  return colors;
}

- (NSUInteger)indexOfCurrentColor
{
  if (!self.color) {
    return 0;
  }
  NSUInteger index = 0;
  NSArray *colorNames = [self colorNames];
  for (NSString *colorName in colorNames) {
    UIColor *colorForName = [self colors][colorName];
    if ([self.color isEqual:colorForName]) {
      return index;
    }
    index++;
  }
  return 0;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tableView registerNib:[UINib nibWithNibName:@"SAColorTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
  [self configureForType];
  selectedIndex = [self indexOfCurrentColor];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
  cell.accessoryType = UITableViewCellAccessoryCheckmark;
  [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)configureForType
{
  if (self.type == SAColorSelectorTypeFill) {
    CGFloat white, alpha;
    [self.color getWhite:&white alpha:&alpha];
    self.slider.value = alpha;
  }

  if (self.type == SAColorSelectorTypeStroke) {
    self.slider.value = self.strokeWidth;
  }
  
  self.sliderValueLabel.text =  [NSString stringWithFormat:@"%.1f", self.slider.value];
}

- (IBAction)done:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
  if (indexPath.row == selectedIndex) {
    return;
  }
  
  NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
  
  UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
  if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
    oldCell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
  if (newCell.accessoryType == UITableViewCellAccessoryNone) {
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedIndex = indexPath.row;
    NSString *key  = [self colorNames][selectedIndex];
    self.color = [self colors][key];
  }
  
  [self.delegate colorPanelView:self didChangeColor:self.color];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[self colorNames] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SAColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  NSUInteger index =  indexPath.row;
  NSString *key  = [self colorNames][index];
  cell.colorName.text = key;
  cell.coloredLabel.layer.borderWidth = 2.0f;
  cell.coloredLabel.layer.borderColor = [[UIColor blackColor] CGColor];
  cell.coloredLabel.backgroundColor = [self colors][key];

  if (indexPath.row == selectedIndex) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}

- (IBAction)sliderAction:(id)sender
{
  CGFloat sliderValue = self.slider.value;
  self.sliderValueLabel.text = [NSString stringWithFormat:@"%.1f", sliderValue];
  
  if (self.type == SAColorSelectorTypeFill) {
    self.color = [self.color colorWithAlphaComponent:sliderValue];
    [self.delegate colorPanelView:self didChangeColor:self.color];
  }
  if (self.type == SAColorSelectorTypeStroke) {
    self.strokeWidth = sliderValue;
    [self.delegate colorPanelView:self didChangeStrokeWidth:self.strokeWidth];
  }
}

@end
