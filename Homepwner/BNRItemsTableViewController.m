//
//  BNRItemsTableViewController.m
//  Homepwner
//
//  Created by test on 12/24/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import "BNRItemsTableViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRDetailViewController.h"
#import "BNRItemCell.h"
#import "BNRImageViewController.h"
#import "BNRImageStore.h"
#import "PopAnimationViewController.h"
#import "PopAnimation.h"
#import "BNRNavDetailViewController.h"

@interface BNRItemsTableViewController () <UIDataSourceModelAssociation >
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (nonatomic) PopAnimationViewController *popAnimationViewController;
@end

@implementation BNRItemsTableViewController
-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
      //  for (int i = 0; i < 5; i++) {
           // [[BNRItemStore shareStore] createItem];
        //}
        
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
        
        
        self.navigationItem.title = @"Homepwner";
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(UIView *)headView
{
    if (_headView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:self options:nil];
    }
    return _headView;
}

-(void)loadView  //在调用loadView之前，VC会先判断view是否为空，空的才会调用此方法。如果此方法未被调用，则viewDidLoad也不会被调。
{
    [super loadView];
//    TableView *mytableview = [[TableView alloc] init];
//    self.tableView = mytableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    
    self.tableView.restorationIdentifier = @"BNRItemsTableViewControllerTableView";
    self.navigationItem.backBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    UINavigationController *nav = [self navigationController];
    //self.popAnimationViewController = [[PopAnimationViewController alloc] initWithNavigationController:nav];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];

  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
   // [self.tableView reloadData];
}


#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[BNRItemStore shareStore] allItems] count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    NSArray *items = [[BNRItemStore shareStore] allItems];
    if (indexPath.row == [items count]) {
        cell.nameLabel.text = @"no more items!";
        [cell.valueLabel setHidden:YES];
        [cell.serialsLabel setHidden:YES];
        [cell.avadarImage setHidden:YES];
    }
    else {
        BNRItem *item = items[indexPath.row];
        cell.nameLabel.text = item.itemName;
        [cell.valueLabel setHidden:NO];
        [cell.serialsLabel setHidden:NO];
        [cell.avadarImage setHidden:NO];
        cell.serialsLabel.text = item.serialNumber;
        
        if (item.valueInDollars > 50) {
            [cell.valueLabel setTextColor:[UIColor greenColor]];
        }
        else
        {
            [cell.valueLabel setTextColor:[UIColor redColor]];
        }
        cell.valueLabel.text = [[NSString alloc] initWithFormat:@"$%d" ,item.valueInDollars] ;
        cell.avadarImage.image = item.thumbnail;
        
        __weak BNRItemCell* weakCell = cell;
        cell.showImageBlock = ^{
           // NSLog(@"VC going to show image for item:%@",item);
            BNRItemCell *cell = weakCell;
            BNRImageViewController *imageViewController = [[BNRImageViewController alloc] init];
           // imageViewController.modalPresentationStyle = UIModalPresentationPopover;
            UIImage *image = [[BNRImageStore sharedStore] imageForKey:item.itemKey];
            imageViewController.image = image;
            
            UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
            imageViewController.navigationItem.leftBarButtonItem = back;
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:imageViewController];
            naVC.modalPresentationStyle = UIModalPresentationPopover;
            [self presentViewController:naVC animated:YES completion:nil];
            
            UIPopoverPresentationController *presentationController = naVC.popoverPresentationController;
            presentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
            presentationController.sourceView = cell.avadarImage;
            CGRect rect = cell.avadarImage.bounds;
            presentationController.sourceRect = CGRectMake(rect.origin.x , rect.origin.y, rect.size.width, rect.size.height);
        };
    }
    return cell;
}

-(void)cancel
{
    [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toggleEditingMode:(id)sender {
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    }
    else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:NO];
    }
}

- (IBAction)addNewItem:(id)sender {
    BNRItem *item = [[BNRItemStore shareStore] createItem];
    BNRDetailViewController *detailController = [[BNRDetailViewController alloc] initForNewItem:YES];
    detailController.item = item;
    detailController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    BNRNavDetailViewController *navigationController = [[BNRNavDetailViewController alloc] initWithRootViewController:detailController];
    detailController.navigationVCInNew = navigationController;
    navigationController.restorationIdentifier = NSStringFromClass([navigationController class]);
    
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    //self.transitioningDelegate = self;
    //self.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:navigationController animated:YES completion:nil];
//    NSInteger lastRow = [[[BNRItemStore shareStore] allItems] indexOfObject:item];
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationLeft];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
*/


/*
// Override to support editing the table view.*/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath.row == [[[BNRItemStore shareStore] allItems] count]) {
            return;
        }
        BNRItem *item = [[BNRItemStore shareStore] allItems][indexPath.row];
        [[BNRItemStore shareStore] removeItem:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
   /* } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   */
}


/*
// Override to support rearranging the table view.*/
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (toIndexPath.row == [[[BNRItemStore shareStore] allItems] count] || fromIndexPath.row == [[[BNRItemStore shareStore] allItems] count]) {
        return;
    }

    [[BNRItemStore shareStore] moveItemfromindex:fromIndexPath.row toIndex:toIndexPath.row];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    if (indexPath.row != [[[BNRItemStore shareStore] allItems] count] - 1){
        return @"删除";
    }
    return @"remove";
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    if (indexPath.row == [[[BNRItemStore shareStore] allItems] count] - 1){
        UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标为未读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"row Action");
        }];
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"remove"handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath1) {
            [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
        }];

        return @[deleteAction,rowAction];
    }//if
    return nil;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[[BNRItemStore shareStore] allItems] count]) {
        return NO;;
    }
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.row == [[[BNRItemStore shareStore] allItems] count]) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[[BNRItemStore shareStore] allItems] count]) {
        return;
    }
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
    BNRItem *item = [[BNRItemStore shareStore] allItems][indexPath.row];
    detailViewController.item = item;
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

#pragma mark -restored
+ (nullable UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.editing forKey:@"self.editing"];
    
    
    [super encodeRestorableStateWithCoder:coder];
    
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.editing = [coder decodeBoolForKey:@"self.editing"];
    
    [super decodeRestorableStateWithCoder:coder];
}

- (nullable NSString *) modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    NSString *identifier = nil;
    NSArray *items = [[BNRItemStore shareStore] allItems];
    BNRItem *item = items[idx.row];
    identifier = item.itemKey;
    return identifier;
}
- (nullable NSIndexPath *) indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSIndexPath *indexPath = nil;
     NSArray *items = [[BNRItemStore shareStore] allItems];
    for (BNRItem *item in items) {
        if ([item.itemKey isEqualToString:identifier] ) {
            NSInteger row = [items indexOfObject:item];
            indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            break;
        }
    }
    return indexPath;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[PopAnimation alloc] init];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
