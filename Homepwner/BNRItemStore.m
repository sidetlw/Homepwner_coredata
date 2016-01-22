//
//  BNRItemStore.m
//  Homepwner
//
//  Created by test on 12/24/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "AppDelegate.h"

@interface BNRItemStore ()
@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic) NSMutableArray *allAssetTypes;
@property (nonatomic) NSMutableArray *itemsForSpecialType;
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSManagedObjectModel *model;
@end

@implementation BNRItemStore
+(instancetype)shareStore
{
    static BNRItemStore *shareStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareStore = [[self alloc] initPrivate];  //BNRItemStore有可能是一个基类，所以在init中使用self alloc

    });
    return shareStore;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"use +[BNRItemStore shareStore]" userInfo:nil];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"open failure" reason:[error localizedDescription] userInfo:nil];
        }
    
    
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];

    }
    return self;
}

-(BNRItem *)createItem
{
    double order ;
    if ([self.privateItems count] == 0) {
        order = 1.0;
    }
    else {
        order = [[self.privateItems lastObject] ordingValue] + 1.0;
    }
    
    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:self.context];
    item.ordingValue = order;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    item.valueInDollars = [defaults integerForKey:BNRNextItemValuePrefsKey];
    item.itemName = [defaults objectForKey:BNRNextItemNamePrefsKey];
    
    NSLog(@"defaults = %@",[defaults dictionaryRepresentation]);
    
    
    [self.privateItems addObject:item];
    return item;
}

-(NSManagedObject *)createAssetType:(NSString *)label
{
    NSManagedObject *type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
    [type setValue:label forKey:@"label"];
    [_allAssetTypes addObject:type];
    return type;
}

-(void)removeItem:(BNRItem *)item
{
    [self.privateItems removeObjectIdenticalTo:item];
    [self.context deleteObject:item];
}

-(void)moveItemfromindex:(NSInteger)fromindex toIndex:(NSInteger)toIndex
{
    if (fromindex == toIndex) {
        return;
    }
    BNRItem *item = self.privateItems[fromindex];
    [self.privateItems removeObjectAtIndex:fromindex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
    double lowbound = 0.0;
    if (toIndex > 0) {
        lowbound = ([self.privateItems[toIndex - 1] ordingValue]);
    }
    else {
        lowbound = [self.privateItems[1] ordingValue] - 2.0;
    }
    
    double highbound = 0.0;
    if (toIndex < [self.privateItems count] - 1) {
        highbound = [self.privateItems[toIndex + 1] ordingValue];
    }
    else {
        highbound = [self.privateItems[toIndex - 1] ordingValue] + 2.0;
    }
    
    double newOrder = (lowbound + highbound) / 2.0;
    item.ordingValue = newOrder;
}

-(NSString *)itemArchivePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *path = [paths firstObject];
   // NSString *filePath = [path stringByAppendingPathComponent:@"items.list"];
    NSString *filePath = [path stringByAppendingPathComponent:@"items.data"];
    return filePath;
}

-(BOOL)saveChanges
{
    NSError *err;
   BOOL sucess = [self.context save:&err];
    if (!sucess) {
        NSLog(@"error to save %@",[err localizedDescription]);
    }
    return sucess;
}

-(NSArray *)allItems
{
    return self.privateItems;
}

-(void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *requst = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRItem" inManagedObjectContext:self.context];
        requst.entity = e;
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"ordingValue" ascending:YES];
        requst.sortDescriptors = @[sd];
        
        NSError *err = nil;
        NSArray *result = [self.context executeFetchRequest:requst error:&err];
        
        if (err) {
            [NSException raise:@"fetch failed" format:@"reason:%@",[err localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(NSArray *)allAssetTypes
{
    if (_allAssetTypes == nil) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *err = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&err];
        if (err != nil) {
            [NSException raise:@"executeFetchRequest error" format:@"reason: %@",[err localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    if ([_allAssetTypes count] == 0) {
        NSManagedObject *type ;//= [[NSManagedObject alloc] init];
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        [type setValue:@"A type" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        [type setValue:@"B type" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        [type setValue:@"C type" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    return _allAssetTypes;
}

-(NSArray *)itemsForSpecialType:(NSString *)mylabel
{
    if (_itemsForSpecialType == nil) {
        NSFetchRequest *requst = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRItem" inManagedObjectContext:self.context];
        requst.entity = e;
        
       // NSPredicate *p = [NSPredicate predicateWithFormat:@"assetType.label == \"B type\""];  //correct
        NSPredicate *p = [NSPredicate predicateWithFormat:@"assetType.label == %@",mylabel];;
        [requst setPredicate:p];
        
        NSError *err = nil;
        NSArray *result = [self.context executeFetchRequest:requst error:&err];
        
        if (err) {
            [NSException raise:@"fetch failed" format:@"reason:%@",[err localizedDescription]];
        }
        
        _itemsForSpecialType = [[NSMutableArray alloc] initWithArray:result];

    }
    return _itemsForSpecialType;
}

-(NSManagedObject *)specialType:(NSString *)mylabel
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRAssetType" inManagedObjectContext:self.context];
    request.entity = e;

    NSPredicate *p = [NSPredicate predicateWithFormat:@"label == %@",mylabel];
    [request setPredicate:p];
    
    NSError *err = nil;
    NSArray *result = [self.context executeFetchRequest:request error:&err];
    if (err != nil) {
        [NSException raise:@"executeFetchRequest specialType error" format:@"reason: %@",[err localizedDescription]];
    }
    return [result firstObject];
}

@end
