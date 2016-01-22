//
//  BNRItem.m
//  Homepwner
//
//  Created by test on 1/8/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

// Insert code here to add functionality to your managed object subclass

-(void)setThumbnailFromImage:(UIImage *)image
{
    CGSize originImageSize = image.size;
    
    CGRect thumbRect = CGRectMake(0, 0, 60, 60);
    CGFloat ratio = MAX(thumbRect.size.width / originImageSize.width, thumbRect.size.height / originImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(thumbRect.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:thumbRect cornerRadius:5.0];
    [path addClip];
    
    CGFloat x = (thumbRect.size.width / 2.0 - ratio * originImageSize.width / 2.0);
    CGFloat y = (thumbRect.size.height / 2.0 - ratio * originImageSize.height / 2.0);
    
    CGRect imageFrame = CGRectMake(x, y, ratio * originImageSize.width, ratio * originImageSize.height);
    
    [image drawInRect:imageFrame];
    self.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    self.dateCreated = [NSDate date];
    self.itemKey = [[NSUUID UUID] UUIDString];
}

@end
