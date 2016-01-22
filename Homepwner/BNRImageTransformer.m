//
//  BNRImageTransformer.m
//  Homepwner
//
//  Created by test on 1/8/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import "BNRImageTransformer.h"
@import UIKit;

@implementation BNRImageTransformer
+ (Class)transformedValueClass    // class of the "output" objects, as returned by transformedValue:
{
    return [NSData class];
}

- (nullable id)transformedValue:(nullable id)value           // by default returns value
{
    if (value == nil) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (nullable id)reverseTransformedValue:(nullable id)value   // by default raises an exception if
{
    return [[UIImage alloc] initWithData:value];
    //return [UIImage imageWithData:value];
}
@end
