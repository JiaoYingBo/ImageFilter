//
//  PhotoFilterViewController.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "PhotoFilterViewController.h"

@interface PhotoFilterViewController ()

@end

@implementation PhotoFilterViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
}

#pragma mark - UI

- (void)setupUI {
    self.navigationItem.title = @"Photo Filters";
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
