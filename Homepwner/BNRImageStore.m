//
//  BNRImageStore.m
//  Homepwner
//
//  Created by test on 12/27/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()
@property (nonatomic) NSMutableDictionary *dictionary;
@end

@implementation BNRImageStore

+(instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });

    return sharedStore;
}

-(instancetype)init
{
    @throw [[NSException alloc] initWithName:@"Singleton" reason:@"user +[BNRImageStore sharedStore]" userInfo:nil];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCaches) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [data writeToFile:[self imagePathForKey:key] atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key
{
    UIImage* result = self.dictionary[key];
    
    if (result == nil) {
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:key]];
        
        if (result != nil) {
            self.dictionary[key] = result;
        }
    }
    return result;
}


-(void)deleteImageForKey:(NSString *)key
{
    if (key == nil) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:[self imagePathForKey:key] error:nil];
}

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *imagepath = [path stringByAppendingPathComponent:key];
    return imagepath;
}

-(void)clearCaches
{
    NSLog(@"side-UIApplicationDidReceiveMemoryWarningNotification");
    [self.dictionary removeAllObjects];
}
@end
