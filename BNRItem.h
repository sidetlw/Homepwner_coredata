//
//  BNRItem.h
//  Homepwner
//
//  Created by test on 1/8/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@import UIKit;
NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
-(void)setThumbnailFromImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END

#import "BNRItem+CoreDataProperties.h"
