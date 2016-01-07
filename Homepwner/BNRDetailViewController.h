//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by test on 12/25/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface BNRDetailViewController : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverPresentationControllerDelegate>
@property (nonatomic) BNRItem *item;
@property (nonatomic,copy) void (^dismissBlock)(void);

-(instancetype)initForNewItem:(BOOL)isNew;

@end
