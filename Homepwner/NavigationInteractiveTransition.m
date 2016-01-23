//
//  NavigationInteractiveTransition.m
//  Homepwner
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 Mrtang. All rights reserved.
//

#import "NavigationInteractiveTransition.h"
#import "PopAnimation.h"

@interface NavigationInteractiveTransition ()

@end

@implementation NavigationInteractiveTransition

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0)
{
    if ([animationController isKindOfClass:[PopAnimation class]]) {
        //_percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        return _percentDrivenInteractiveTransition;
    }
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    if (operation == UINavigationControllerOperationPop) {
        return [[PopAnimation alloc] init];
    }
    return nil;
}
@end
