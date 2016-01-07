//
//  BNRItemCell.m
//  Homepwner
//
//  Created by test on 1/4/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)showImage:(id)sender {
    if (self.showImageBlock != nil) {
        self.showImageBlock();
    }
}

@end
