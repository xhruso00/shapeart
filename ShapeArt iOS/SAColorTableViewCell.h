//
//  SAColorTableViewCell.h
//  ShapeArt
//
//  Created by Marek Hrusovsky on 24/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAColorTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *colorName;
@property (nonatomic, strong) IBOutlet UILabel *coloredLabel;
@end
