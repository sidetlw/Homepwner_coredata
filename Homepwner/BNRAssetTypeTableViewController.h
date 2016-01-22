//
//  BNRAssetTypeTableViewController.h
//  Homepwner
//
//  Created by test on 1/9/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRItem.h"

@interface BNRAssetTypeTableViewController : UITableViewController
@property (nonatomic) BNRItem *item;
@property (nonatomic, copy) void (^dissmissBlock)(void);
@end
