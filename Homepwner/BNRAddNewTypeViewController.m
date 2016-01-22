//
//  BNRAddNewTypeViewController.m
//  Homepwner
//
//  Created by test on 1/9/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import "BNRAddNewTypeViewController.h"

@interface BNRAddNewTypeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BNRAddNewTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addButtonTapped:(id)sender {
    if (self.dissmissBlock) {
        self.dissmissBlock(self.textField.text); //调用也是c++语法
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
