//
//  UIView+UIView_CubicAnimation.m
//  喵喵炭
//
//  Created by 喵喵炭 on 2018/3/9.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "UIView+CubicAnimation.h"
#define kInterPolation_Count 10

/**
 所生成的关键帧动画的插值回调，
 
 @param values 所生成的关键帧动画的values数组
 @param timingFunctions 所生成的关键帧动画的timingFunctions数组
 @param index values和timingFunctions的将要插入数据的索引
 @param count values和timingFunctions最终需要填入的数据量
 */
typedef void (^InterpolationProcessingBlock)(NSMutableArray* values, NSMutableArray * timingFunctions, NSInteger index, NSInteger count);

@interface CAAnimation (CAAnimation_CubicAnimation)

/**
 关键帧动画

 @param keyPath 生成关键帧动画的keyPath
 @param count 动画的valus数组中的个数
 @param duration 执行时间
 @param block values和timingFunctions中插入数值的回调
 @return 关键帧动画对象
 */
+ (CAKeyframeAnimation*)animationInterpolationCurveWithKeyPath:(NSString*)keyPath
                                        withInterPolationCount:(NSInteger)count
                                                  withDuration:(NSTimeInterval)duration
                                           withProcessingBlock:(InterpolationProcessingBlock)block;

@end

@implementation UIView (UIView_CubicAnimation)

- (void)cubicAnimationWithCurrentShowView:(UIView *)currentView
                          willPresentView:(UIView *)willPresentView
                                direction:(CubicAnimationDirection)direction
                        animationDuration:(CGFloat)duration
                           completeHandle:(void (^)(void))completeHandle
{
    if (currentView && willPresentView) {
        CATransform3D transform3D = CATransform3DIdentity;
        transform3D.m34 = 0.0007;
        self.layer.sublayerTransform = transform3D;
        [self configeTransactionWithCurrentShowView:currentView
                                    willPresentView:willPresentView
                                          direction:direction
                                  animationDuration:duration
                                     completeHandle:completeHandle];
    } else {
        NSString *assert = [NSString stringWithFormat:@"%@ can not be nil", !currentView ? @"currentView" : @"willPresentView"];
        NSAssert(YES, assert);
    }
}

- (void)configeTransactionWithCurrentShowView:(UIView *)currentView
                              willPresentView:(UIView *)willPresentView
                                    direction:(CubicAnimationDirection)direction
                            animationDuration:(CGFloat)duration
                               completeHandle:(void (^)(void))completeHandle
{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    //不能放到commit之后，否则会提前被调用
    [CATransaction setCompletionBlock:^{
        if (completeHandle) completeHandle();
    }];
    switch (direction) {
        case CubicAnimationDirectionTurnToLeft:
            [self cubicAnimationTurnToLeftWithCurrentShowView:currentView
                                              willPresentView:willPresentView
                                            animationDuration:duration];
            break;
        case CubicAnimationDirectionTurnToRight:
            [self cubicAnimationTurnToRightWithCurrentShowView:currentView
                                               willPresentView:willPresentView
                                             animationDuration:duration];
            break;
        case CubicAnimationDirectionTurnToTop:
            [self cubicAnimationTurnToTopWithCurrentShowView:currentView
                                             willPresentView:willPresentView
                                           animationDuration:duration];
            break;
        case CubicAnimationDirectionTurnToBottom:
            [self cubicAnimationTurnToBottomWithCurrentShowView:currentView
                                                willPresentView:willPresentView
                                              animationDuration:duration];
            break;
        default:
            break;
    }
    [CATransaction commit];
    [self bringSubviewToFront:willPresentView];
}

- (void)cubicAnimationTurnToLeftWithCurrentShowView:(UIView *)currentView
                                    willPresentView:(UIView *)willPresentView
                                  animationDuration:(CGFloat)duration
{
    CGFloat raidus = CGRectGetWidth(currentView.frame) / 2;
    CAAnimation *currentViewAnimation = [self cubeAnimationCenterToLeftWithRadius:raidus
                                                                         duration:duration];
    [currentView.layer addAnimation:currentViewAnimation forKey:nil];
    
    CAAnimation *willPresentViewAnimation = [self cubeAnimationRightToCenterWithRadius:raidus
                                                                              duration:duration];
    [willPresentView.layer addAnimation:willPresentViewAnimation forKey:nil];
}

- (void)cubicAnimationTurnToRightWithCurrentShowView:(UIView *)currentView
                                     willPresentView:(UIView *)willPresentView
                                   animationDuration:(CGFloat)duration
{
    CGFloat radius = CGRectGetWidth(currentView.frame) / 2;
    CAAnimation *currentViewAnimation = [self cubicAnimationCenterToRightWithRadius:radius
                                                                           duration:duration];
    [currentView.layer addAnimation:currentViewAnimation forKey:nil];
    CAAnimation *willPresetnViewAnimation = [self cubicAnimationLeftToCenterWithRadius:radius
                                                                              duration:duration];
    [willPresentView.layer addAnimation:willPresetnViewAnimation forKey:nil];
}

- (void)cubicAnimationTurnToTopWithCurrentShowView:(UIView *)currentView
                                   willPresentView:(UIView *)willPresentView
                                 animationDuration:(CGFloat)duration
{
    CGFloat radius = CGRectGetHeight(currentView.frame) / 2;
    CAAnimation *currentViewAnimation = [self cubeAnimationCenterToTopWithRadius:radius
                                                                        duration:duration];
    [currentView.layer addAnimation:currentViewAnimation forKey:nil];
    CAAnimation *willPresetnViewAnimation = [self cubeAnimationBottomToCenterWithRadius:radius
                                                                               duration:duration];
    [willPresentView.layer addAnimation:willPresetnViewAnimation forKey:nil];
}

- (void)cubicAnimationTurnToBottomWithCurrentShowView:(UIView *)currentView
                                      willPresentView:(UIView *)willPresentView
                                    animationDuration:(CGFloat)duration
{
    CGFloat radius = CGRectGetHeight(currentView.frame) / 2;
    CAAnimation *currentViewAnimation = [self cubeAnimationCenterToBottomWithRadius:radius
                                                                           duration:duration];
    [currentView.layer addAnimation:currentViewAnimation forKey:nil];
    CAAnimation *willPresetnViewAnimation = [self cubeAnimationTopToCenterWithRadius:radius
                                                                            duration:duration];
    [willPresentView.layer addAnimation:willPresetnViewAnimation forKey:nil];
}

/**
 当前View上移
 
 @param radius 旋转半径
 @param duration 旋转时间
 @return 关键帧动画对象
 */
- (CAAnimation *)cubeAnimationCenterToTopWithRadius:(CGFloat)radius
                                           duration:(CGFloat)duration
{
    return [self animationGroupWithRadius:radius
                                 duration:duration
                     opacityChangedToZero:YES
                          processingBlock:^(NSMutableArray *values, NSMutableArray *timingFunctions, NSInteger index, NSInteger count) {
                              CGFloat radian = M_PI_2 * index / (count -1);
                              CATransform3D transform3d = CATransform3DMakeTranslation(0, -radius * sinf(radian), radius * (1 - cosf(radian)));
                              transform3d = CATransform3DRotate(transform3d, radian, -1.f, 0, 0);
                              NSValue *value = [NSValue valueWithCATransform3D:transform3d];
                              [values addObject:value];
                              [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
                          }];
}
/**
 将展示的View上移
 
 @param radius 旋转半径
 @param duration 旋转时间
 @return 关键帧动画对象
 */
- (CAAnimation *)cubeAnimationBottomToCenterWithRadius:(CGFloat)radius
                                              duration:(CGFloat)duration
{
    return [self animationGroupWithRadius:radius
                                 duration:duration
                     opacityChangedToZero:NO
                          processingBlock:^(NSMutableArray *values, NSMutableArray *timingFunctions, NSInteger index, NSInteger count) {
                              CGFloat radian = M_PI_2 * (count - 1 - index) / (count - 1);
                              CATransform3D transform3d = CATransform3DMakeTranslation(0, radius * sinf(radian), radius * (1 - cosf(radian)));
                              transform3d = CATransform3DRotate(transform3d, radian, 1.f, 0, 0);
                              NSValue *value = [NSValue valueWithCATransform3D:transform3d];
                              [values addObject:value];
                              [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
                          }];
}
/**
 当前View下移
 
 @param radius 旋转半径
 @param duration 旋转时间
 @return 关键帧动画对象
 */
- (CAAnimation *)cubeAnimationCenterToBottomWithRadius:(CGFloat)radius
                                              duration:(CGFloat)duration
{
    return [self animationGroupWithRadius:radius
                                 duration:duration
                     opacityChangedToZero:YES
                          processingBlock:^(NSMutableArray *values, NSMutableArray *timingFunctions, NSInteger index, NSInteger count) {
                              CGFloat radian = M_PI_2 * index / (count -1);
                              CATransform3D transform3d = CATransform3DMakeTranslation(0, radius * sinf(radian), radius * (1-cosf(radian)));
                              transform3d = CATransform3DRotate(transform3d, radian, 1.f, 0, 0);
                              NSValue *value = [NSValue valueWithCATransform3D:transform3d];
                              [values addObject:value];
                              [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
                          }];
}
/**
 将展示的View下移
 
 @param radius 旋转半径
 @param duration 旋转时间
 @return 关键帧动画对象
 */
- (CAAnimation *)cubeAnimationTopToCenterWithRadius:(CGFloat)radius
                                           duration:(CGFloat)duration
{
    return [self animationGroupWithRadius:radius
                                 duration:duration
                     opacityChangedToZero:NO
                          processingBlock:^(NSMutableArray *values, NSMutableArray *timingFunctions, NSInteger index, NSInteger count) {
                              CGFloat radian = M_PI_2 * (count - 1 - index) / (count -1);
                              CATransform3D transform3d = CATransform3DMakeTranslation(0, -radius * sinf(radian), radius * (1 - cosf(radian)));
                              transform3d = CATransform3DRotate(transform3d, radian, -1.f, 0, 0);
                              NSValue *value = [NSValue valueWithCATransform3D:transform3d];
                              [values addObject:value];
                              [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
                          }];
}
/**
 当前View左移
 
 @param radius 旋转半径
 @param duration 旋转时间
 @return 关键帧动画对象
 */
- (CAAnimation *)cubeAnimationCenterToLeftWithRadius:(CGFloat)radius
                                            duration:(CGFloat)duration
{
    return [self animationGroupWithRadius:radius
                                 duration:duration
                     opacityChangedToZero:YES
                          processingBlock:^(NSMutableArray *values, NSMutableArray *timingFunctions, NSInteger index, NSInteger count) {
                              CGFloat radian = M_PI_2 * index / (count - 1);
                              CATransform3D transform = CATransform3DMakeTranslation(-radius * sinf(radian), 0, radius *(1 - cosf(radian)));
                              transform = CATransform3DRotate(transform, radian, 0, 1, 0);
                              NSValue *value = [NSValue valueWithCATransform3D:transform];
                              [values addObject:value];
                              CAMediaTimingFunction *timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                              [timingFunctions addObject:timingFunction];
                          }];
}

/**
 将展示的View左移
 
 @param radius 旋转半径
 @param duration 旋转时间
 @return 关键帧动画对象
 */
- (CAAnimation *)cubeAnimationRightToCenterWithRadius:(CGFloat)radius
                                             duration:(CGFloat)duration
{
    return [self animationGroupWithRadius:radius
                                 duration:duration
                     opacityChangedToZero:NO
                          processingBlock:^(NSMutableArray *values, NSMutableArray *timingFunctions, NSInteger index, NSInteger count) {
                              CGFloat radian = M_PI_2 *(count - 1 - index) / (count - 1);
                              CATransform3D transform = CATransform3DMakeTranslation(radius * sinf(radian), 0,  radius *(1 - cosf(radian)));
                              transform = CATransform3DRotate(transform, radian, 0, -1, 0);
                              NSValue *value = [NSValue valueWithCATransform3D:transform];
                              [values addObject:value];
                              CAMediaTimingFunction *timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                              [timingFunctions addObject:timingFunction];
                          }];
}
/**
 当前View右移
 
 @param radius 旋转半径
 @param duration 旋转时间
 @return 关键帧动画对象
 */
- (CAAnimationGroup *)cubicAnimationCenterToRightWithRadius:(CGFloat)radius
                                                   duration:(CGFloat)duration
{
    return [self animationGroupWithRadius:radius
                                  duration:duration
                      opacityChangedToZero:YES
                           processingBlock:^(NSMutableArray *values, NSMutableArray *timingFunctions, NSInteger index, NSInteger count) {
                               CGFloat radian = M_PI_2 * index / (count - 1);
                               CATransform3D transform3D = CATransform3DMakeTranslation(radius * sinf(radian), 0, radius * (1 - cosf(radian)));
                               transform3D = CATransform3DRotate(transform3D, radian, 0, -1, 0);
                               NSValue *value = [NSValue valueWithCATransform3D:transform3D];
                               [values addObject:value];
                               CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                               [timingFunctions addObject:timingFunction];
                           }];
}
/**
将展示的View右移
 
 @param radius 旋转半径
 @param duration 旋转时间
 @return 关键帧动画对象
 */
- (CAAnimationGroup *)cubicAnimationLeftToCenterWithRadius:(CGFloat)radius
                                                  duration:(CGFloat)duration
{
    return [self animationGroupWithRadius:radius
                                 duration:duration
                     opacityChangedToZero:NO
                          processingBlock:^(NSMutableArray *values, NSMutableArray *timingFunctions, NSInteger index, NSInteger count) {
                              CGFloat radian = M_PI_2 *(count - 1 - index) / (count - 1);
                              CATransform3D transform3D = CATransform3DMakeTranslation(-radius * sinf(radian), 0, radius * (1 - cosf(radian)));
                              transform3D = CATransform3DRotate(transform3D, radian, 0, 1, 0);
                              NSValue *value = [NSValue valueWithCATransform3D:transform3D];
                              [values addObject:value];
                              CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                              [timingFunctions addObject:timingFunction];
                          }];
}

/**
 生成opacity属性动画

 @param toZero opacity是否减小到0
 @param duration 动画执行的时间
 @param timingFunction 动画执行的时间函数，或快慢
 @return baseAnimation对象，toZero = YES，layer的透明度减小，反之增大
 */
- (CABasicAnimation *)viewLayerOpacityChangedAnimation:(BOOL)toZero
                                              duration:(CGFloat)duration
                                        timingFunction:(CAMediaTimingFunction *)timingFunction
{
    CGFloat fromValue = 0.1, toValue = 1;
    if (toZero) {
        fromValue = 1;
        toValue = 0.1;
    }
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation.fromValue = @(fromValue);
    basicAnimation.toValue = @(toValue);
    basicAnimation.duration = duration;
    CAMediaTimingFunction *function;
    if (!toZero) {
        function = [CAMediaTimingFunction functionWithControlPoints:0.1 :1 :1 :1];
    } else {
        function = [CAMediaTimingFunction functionWithControlPoints:0.9 :0 :1 :1];
    }
    basicAnimation.timingFunction = function;
    return basicAnimation;
}

/**
 生成group动画

 @param animations 动画数组
 @param duration 动画执行的时间
 @return group动画
 */
- (CAAnimationGroup *)animationGroupWithAnimations:(NSArray<CAAnimation *> *)animations
                                          duration:(CGFloat)duration
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;
    animationGroup.animations = [NSArray arrayWithArray:animations];
    return animationGroup;
}

/**
 生成group动画

 @param radius 关键帧动画transform的旋转半径
 @param duration 动画时间
 @param toZero 属性动画opacity是否减小到0
 @param processBlock 关键帧动画的进程回调
 @return group动画对象
 */
- (CAAnimationGroup *)animationGroupWithRadius:(CGFloat)radius
                                      duration:(CGFloat)duration
                          opacityChangedToZero:(BOOL)toZero
                               processingBlock:(InterpolationProcessingBlock)processBlock
{
    CAKeyframeAnimation *animation =
    [CAAnimation animationInterpolationCurveWithKeyPath:@"transform"
                                 withInterPolationCount:kInterPolation_Count
                                           withDuration:duration
                                    withProcessingBlock:^(NSMutableArray *values, NSMutableArray *timingFunctions, NSInteger index, NSInteger count) {
                                        if (processBlock) {
                                            processBlock(values, timingFunctions, index, count);
                                        }
                                    }];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CABasicAnimation *opacityAnimation =
    [self viewLayerOpacityChangedAnimation:toZero
                                  duration:duration
                            timingFunction:timingFunction];
    CAAnimationGroup *cubicAnimation =
    [self animationGroupWithAnimations:@[animation, opacityAnimation]
                              duration:duration];
    return cubicAnimation;
}

@end

@implementation CAAnimation ( CAAnimation_CubicAnimation )

+ (CAKeyframeAnimation*)animationInterpolationCurveWithKeyPath:(NSString*)keyPath
                                        withInterPolationCount:(NSInteger)count
                                                  withDuration:(NSTimeInterval)duration
                                           withProcessingBlock:(void (^)(NSMutableArray* values,NSMutableArray * timingFunctions,NSInteger index,NSInteger count))block{
    if ([keyPath isEqualToString:@""]||keyPath == nil ||count <2) {
        return nil;
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *timingFunctions = [NSMutableArray array];
    for (int i = 0; i< count; i ++) {
        block(values,timingFunctions,i, count);
    }
    animation.values = values;
    animation.timingFunctions = timingFunctions;
    animation.duration = duration;
    return animation;
}

@end
