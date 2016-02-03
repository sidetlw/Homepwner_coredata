//
//  BNRNavDetailViewController.m
//  Homepwner
//
//  Created by test on 16/2/3.
//  Copyright © 2016年 Mrtang. All rights reserved.
//

#import "BNRNavDetailViewController.h"
#import "PopAnimation.h"

@interface BNRNavDetailViewController () <UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>
@property (nonatomic) UIScreenEdgePanGestureRecognizer *panGesture;
@property (nonatomic) UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;
@end

@implementation BNRNavDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandel:)];
    _panGesture.edges = UIRectEdgeLeft;
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:_panGesture];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)panGestureHandel:(UIPanGestureRecognizer *)gesture
{
    CGPoint transpoint = [gesture translationInView:self.view];
    CGFloat process = transpoint.x / self.view.bounds.size.width;
    process = MIN( MAX(0.0, process),1.0);
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;

        self.percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.deleteItemBlock) {
                self.deleteItemBlock();
            }
        }];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenInteractiveTransition updateInteractiveTransition:process];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (process > 0.5) {
            [self.percentDrivenInteractiveTransition finishInteractiveTransition];
        }
        else {
            [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        self.percentDrivenInteractiveTransition = nil;
    }
}


#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[PopAnimation alloc] init];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.percentDrivenInteractiveTransition;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
