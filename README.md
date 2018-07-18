# CubeAnimation

Cube转场动画

```
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
                           
```
