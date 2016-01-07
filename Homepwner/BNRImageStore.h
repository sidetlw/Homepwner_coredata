//
//  BNRImageStore.h
//  Homepwner
//
//  Created by test on 12/27/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class UIImage;

@interface BNRImageStore : NSObject
+(instancetype)sharedStore;
-(void)setImage:(UIImage *)image forKey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImageForKey:(NSString *)key;

@end
