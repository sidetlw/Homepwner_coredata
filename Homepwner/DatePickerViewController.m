//
//  DatePickerViewController.m
//  Homepwner
//
//  Created by test on 12/26/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import "DatePickerViewController.h"
#import "BNRItem.h"

@interface DatePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.datePicker.date = self.currentDate;
    self.datePicker.date = self.pickerItem.dateCreated;
}

- (IBAction)buttonTapped:(id)sender {
   // self.currentDate = self.datePicker.date;
    self.pickerItem.dateCreated = self.datePicker.date;
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
