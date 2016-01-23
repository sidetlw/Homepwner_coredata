//
//  PopAnimation.m
//  Homepwner
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 Mrtang. All rights reserved.
//

#import "PopAnimation.h"

@implementation PopAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];
    [container insertSubview:toVC.view belowSubview:fromVC.view];
    CGRect tempframe = toVC.view.frame;
    CGRect frame = toVC.view.frame;
    frame.origin.x -= 300.0;
    toVC.view.frame = frame;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.transform = CGAffineTransformMakeTranslation([[UIScreen mainScreen] bounds].size.width, 0);
        toVC.view.frame = tempframe;

    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!([transitionContext transitionWasCancelled])];
         toVC.view.frame = tempframe;
    }];
    
    
}

@end
