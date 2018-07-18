//
//  TransitionAnimation.m
//  CubeAnimation_Demo
//
//  Created by zhiantech-007 on 2018/7/18.
//  Copyright © 2018年 喵喵炭. All rights reserved.
//

#import "TransitionAnimation.h"
#import "UIView+CubicAnimation.h"

@implementation TransitionAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //cubic Animation
    [self cubicAnimationWithTransition:transitionContext];
    //反转
    
}

- (void)cubicAnimationWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    [containerView insertSubview:toVC.view atIndex:0];
    
    [containerView cubicAnimationWithCurrentShowView:fromVC.view
                                     willPresentView:toVC.view
                                           direction:self.isBack ? CubicAnimationDirectionTurnToRight : CubicAnimationDirectionTurnToLeft
                                   animationDuration:[self transitionDuration:transitionContext]
                                      completeHandle:^{
                                          [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                      }];
}
    
@end
