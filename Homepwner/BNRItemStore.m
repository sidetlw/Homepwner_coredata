//
//  BNRItemStore.m
//  Homepwner
//
//  Created by test on 12/24/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore ()
@property (nonatomic) NSMutableArray *privateItems;
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
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:[self itemArchivePath]];
        
        if (_privateItems == nil) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    [self.privateItems addObject:item];
    return item;
}

-(void)removeItem:(BNRItem *)item
{
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void)moveItemfromindex:(NSInteger)fromindex toIndex:(NSInteger)toIndex
{
    if (fromindex == toIndex) {
        return;
    }
    BNRItem *item = self.privateItems[fromindex];
    [self.privateItems removeObjectAtIndex:fromindex];
    [self.privateItems insertObject:item atIndex:toIndex];
}

-(NSString *)itemArchivePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *path = [paths firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"items.list"];
    return filePath;
}

-(BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

-(NSArray *)allItems
{
    return self.privateItems;
}
@end
