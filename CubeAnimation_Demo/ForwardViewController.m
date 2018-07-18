//
//  ForwardViewController.m
//  CubeAnimation_Demo
//
//  Created by zhiantech-007 on 2018/7/18.
//  Copyright © 2018年 喵喵炭. All rights reserved.
//

#import "ForwardViewController.h"

@interface ForwardViewController ()

@end

@implementation ForwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    UILabel *label = [UILabel new];
    [label setText:@"This is the an another page"];
    [label sizeToFit];
    [label setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4)];;
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button sizeToFit];
    [button setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClicked:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
