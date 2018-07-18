//
//  ViewController.m
//  CubeAnimation_Demo
//
//  Created by zhiantech-007 on 2018/7/18.
//  Copyright © 2018年 喵喵炭. All rights reserved.
//

#import "MainViewController.h"
#import "ForwardViewController.h"
#import "TransitionAnimation.h"

@interface MainViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) TransitionAnimation *transitionAnimation;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [UILabel new];
    [label setText:@"This is mian page"];
    [label sizeToFit];
    [label setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4)];;
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor cyanColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Forward" forState:UIControlStateNormal];
    [button sizeToFit];
    [button setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Actions

- (void)buttonClicked {
    ForwardViewController *vc = [ForwardViewController new];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.transitionAnimation.isBack = NO;
    return self.transitionAnimation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transitionAnimation.isBack = YES;
    return self.transitionAnimation;
}

#pragma mark - getters

- (TransitionAnimation *)transitionAnimation {
    if (!_transitionAnimation) {
        _transitionAnimation = [TransitionAnimation new];
    }
    return _transitionAnimation;
}

@end
