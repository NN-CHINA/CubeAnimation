//
//  UIView+UIView_CubicAnimation.h
//  喵喵炭
//
//  Created by 喵喵炭 on 2018/3/9.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, CubicAnimationDirection) {
    CubicAnimationDirectionTurnToLeft,//向左旋转
    CubicAnimationDirectionTurnToRight,//向右旋转
    CubicAnimationDirectionTurnToTop,//向上旋转
    CubicAnimationDirectionTurnToBottom,//向下旋转
};

@interface UIView (UIView_CubicAnimation) <CAAnimationDelegate>

/**
 cubic Animation

 @param currentView 当前展示的view
 @param willPresentView 将要展示的view
 @param direction 动画执行的方向
 @param duration 动画执行的时间
 @param completeHandle 动画完成后的操作
 */
- (void)cubicAnimationWithCurrentShowView:(UIView *)currentView
                          willPresentView:(UIView *)willPresentView
                                direction:(CubicAnimationDirection)direction
                        animationDuration:(CGFloat)duration
                           completeHandle:(void(^)(void))completeHandle;
@end

