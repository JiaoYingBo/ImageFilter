//
//  IFBaseViewController.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/2.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFBaseViewController.h"
#import "IFEditorViewController.h"

@interface IFBaseViewController ()

@end

@implementation IFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[IFEditorViewController class]]) {
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
//        leftButton.imageView.contentMode = UIViewContentModeCenter;
//        leftButton.adjustsImageWhenHighlighted = NO;
//        leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//        [leftButton setImage:[UIImage imageNamed:@"bule-back"] forState:UIControlStateNormal];
//        [leftButton setImage:[UIImage imageNamed:@"blue-icon-pressed"] forState:UIControlStateHighlighted];
//        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        
        UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [right addTarget:self action:@selector(goOnClick) forControlEvents:UIControlEventTouchUpInside];
        right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [right setTitle:@"继续" forState:UIControlStateNormal];
        [right.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [right setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [right setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
        self.navigationItem.rightBarButtonItem = rightItem;
    }*/
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goOnClick {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
