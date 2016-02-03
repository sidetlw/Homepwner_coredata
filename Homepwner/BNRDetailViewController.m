//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by test on 12/25/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "DatePickerViewController.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "BNRAssetTypeTableViewController.h"
#import "AppDelegate.h"
#import "PopAnimation.h"
#import "BNRNavDetailViewController.h"

@interface BNRDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *cameraOverView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *takePhotoButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetType;

@end

@implementation BNRDetailViewController

-(instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew == YES) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
   }

    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"wrong initializer" reason:@"use initForNewItem:" userInfo:nil];
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapped)];
    [self.view addGestureRecognizer:gesture];
    
    if (self.navigationVCInNew != nil) {
        self.navigationVCInNew.deleteItemBlock = ^{
            [[BNRItemStore shareStore] removeItem:self.item];
        };
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    self.nameField.text = self.item.itemName;
    self.serialField.text = self.item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", self.item.valueInDollars];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年M月dd日 HH:mm";
    NSString *dateString = [dateFormatter stringFromDate:self.item.dateCreated];
    self.dateLabel.text = dateString;
    
    self.imageView.image = [[BNRImageStore sharedStore] imageForKey:self.item.itemKey];
    
    NSManagedObject *type = self.item.assetType;
    if (type != nil) {
         self.assetType.title = [[NSString alloc] initWithFormat:@"type:%@",[type valueForKey:@"label"]];
    }
    else {
        self.assetType.title = @"type:none";
    }
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.view endEditing:YES];
//    self.item.itemName = self.nameField.text;
//    self.item.serialNumber = self.serialField.text;
//   
//    int newValue = [self.valueField.text intValue];
//    if (newValue != self.item.valueInDollars) {
//        self.item.valueInDollars = newValue;
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setInteger:newValue forKey:BNRNextItemValuePrefsKey];
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = item.itemName;
}
- (IBAction)changeDateTapped:(id)sender {
    DatePickerViewController *dateController = [[DatePickerViewController alloc] init];
    dateController.pickerItem = self.item;
    [[self navigationController] pushViewController:dateController animated:YES];
}

-(UIView *)cameraOverView
{
    if (_cameraOverView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CameraOverLayView" owner:self options:nil];
    }
    return _cameraOverView;
}

-(void)gestureTapped
{
    [self.view endEditing:YES];
}

- (IBAction)cameraButtonTapped:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePickerController.mediaTypes = mediaTypes;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        UIView *view = self.cameraOverView;
        view.frame = CGRectMake(imagePickerController.view.center.x - 30, imagePickerController.view.center.y - 30, 60, 60);
        imagePickerController.cameraOverlayView = view;
    }
    else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePickerController.delegate = self;
    
    imagePickerController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:imagePickerController animated:YES completion:nil];

    UIPopoverPresentationController *presentationController = [imagePickerController popoverPresentationController];
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    presentationController.delegate = self;
    presentationController.barButtonItem = self.takePhotoButton;
    
    imagePickerController.allowsEditing = YES;
}

- (IBAction)deleteButtonTapped:(id)sender {
    [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
    self.imageView.image = [[BNRImageStore sharedStore] imageForKey:self.item.itemKey];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    self.imageView.image = image;
    [self.item setThumbnailFromImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)save
{
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialField.text;

    int newValue = [self.valueField.text intValue];
    if (newValue != self.item.valueInDollars) {
        self.item.valueInDollars = newValue;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue forKey:BNRNextItemValuePrefsKey];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

-(void)cancel
{
    NSLog(@"canceled");
    [[BNRItemStore shareStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (IBAction)assetTypeButtonTapped:(id)sender {
    BNRAssetTypeTableViewController *vc = [[BNRAssetTypeTableViewController alloc] init];
    vc.item = self.item;
    vc.dissmissBlock = ^{
        self.assetType.title = [self.item.assetType valueForKey:@"label"];
    };
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    navVC.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:navVC animated:YES completion:nil];
    
    UIPopoverPresentationController *presentVC = navVC.popoverPresentationController;
    presentVC.barButtonItem = self.assetType;
}

#pragma mark - restored
+ (nullable UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isnew = NO;
    if ([identifierComponents count] == 3) {
        isnew = YES;
    }
    return [[self alloc] initForNewItem:isnew];
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
    [[BNRItemStore shareStore] saveChanges];
    
    
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    NSArray *items = [[BNRItemStore shareStore] allItems];
    for (BNRItem* item in items) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }//for
    [super decodeRestorableStateWithCoder:coder];
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
