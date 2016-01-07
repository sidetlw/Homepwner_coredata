//
//  BNRItemCell.h
//  Homepwner
//
//  Created by test on 1/4/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avadarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic,copy) void(^showImageBlock)(void);
@end
