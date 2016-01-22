//
//  BNRItemStore.h
//  Homepwner
//
//  Created by test on 12/24/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//
@import CoreData;
#import <Foundation/Foundation.h>
@class BNRItem;

@interface BNRItemStore : NSObject
@property (nonatomic, readonly) NSArray *allItems;

+(instancetype)shareStore;
-(BNRItem *)createItem;
-(NSManagedObject *)createAssetType:(NSString *)label;
-(void)removeItem:(BNRItem*)item;
-(void)moveItemfromindex:(NSInteger)fromindex toIndex:(NSInteger)toIndex;
-(BOOL)saveChanges;
-(NSArray *)allAssetTypes;
-(NSArray *)itemsForSpecialType:(NSString *)mylabel;
@end
