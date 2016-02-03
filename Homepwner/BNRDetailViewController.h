//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by test on 12/25/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;
@class BNRNavDetailViewController;

@interface BNRDetailViewController : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverPresentationControllerDelegate, UIViewControllerRestoration>
@property (nonatomic) BNRItem *item;
@property (nonatomic,copy) void (^dismissBlock)(void);
@property (weak, nonatomic) BNRNavDetailViewController *navigationVCInNew;

-(instancetype)initForNewItem:(BOOL)isNew;

@end
