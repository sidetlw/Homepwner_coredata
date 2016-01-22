//
//  BNRAssetTypeTableViewController.m
//  Homepwner
//
//  Created by test on 1/9/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import "BNRAssetTypeTableViewController.h"
#import "BNRItemStore.h"
#import "BNRAddNewTypeViewController.h"

@interface BNRAssetTypeTableViewController () <UITableViewDelegate>
@property (nonatomic) NSArray *types;
@property (nonatomic) NSString *mylabel;
@end

@implementation BNRAssetTypeTableViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    _mylabel = @"B type";
    return self;

}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _types = [[BNRItemStore shareStore] allAssetTypes];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"types";
    }
    else {
        return @"item of special assetType";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.types.count;
    }
    else {
        NSLog(@"itemsForSpecialType count = %lu",(unsigned long)[[[BNRItemStore shareStore] itemsForSpecialType:self.mylabel] count]);
        return [[[BNRItemStore shareStore] itemsForSpecialType:self.mylabel] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSManagedObject * type = self.types[indexPath.row];
        NSString *text = [type valueForKey:@"label"];
        cell.textLabel.text = text;
        
        if (type == self.item.assetType) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        BNRItem *item = [[BNRItemStore shareStore] itemsForSpecialType:self.mylabel][indexPath.row];
        cell.textLabel.text = item.itemName;
    }

    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSManagedObject * type = self.types[indexPath.row];
        self.item.assetType = type;
        
        if (self.dissmissBlock) {
            self.dissmissBlock();
        }
    }
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [queue addOperationWithBlock:^{
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

-(void)addButtonTapped
{
    BNRAddNewTypeViewController *addVC = [[BNRAddNewTypeViewController alloc] init];
    addVC.dissmissBlock = ^(NSString *typeLabel){
        [[BNRItemStore shareStore] createAssetType:typeLabel];
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:addVC animated:YES];
}

-(void)cancelButtonTapped
{
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [queue addOperationWithBlock:^{
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

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
