//
//  DatePickerViewController.h
//  Homepwner
//
//  Created by test on 12/26/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface DatePickerViewController : UIViewController
@property (nonatomic) NSDate *currentDate;
@property (nonatomic) BNRItem *pickerItem;
@end
