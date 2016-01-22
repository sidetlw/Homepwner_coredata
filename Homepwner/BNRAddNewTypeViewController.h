//
//  BNRAddNewTypeViewController.h
//  Homepwner
//
//  Created by test on 1/9/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRAddNewTypeViewController : UIViewController
@property (nonatomic,copy) void (^dissmissBlock)(NSString *type); //block执行的是c++的语法
@end
