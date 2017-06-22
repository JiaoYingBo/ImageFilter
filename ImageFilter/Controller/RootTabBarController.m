//
//  RootTabBarController.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "RootTabBarController.h"
#import "FilterListViewController.h"
#import "PhotoFilterViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewControllers];
}

- (void)addChildViewControllers {
    FilterListViewController *firstTabVC = [[FilterListViewController alloc] init];
    PhotoFilterViewController *secondTabVC = [[PhotoFilterViewController alloc] init];
    
    NSArray *vcArray = @[firstTabVC,secondTabVC];
    
    NSArray *imageArray = @[@"filter-icon", @"photos-icon"];
    NSArray *titleArray = @[@"Filters", @"Photos"];
    
    for (int i = 0; i < vcArray.count; i ++) {
        [self addChildVC:vcArray[i] title:titleArray[i] imageName:imageArray[i]];
    }
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName {
    self.tabBar.tintColor = [UIColor blackColor];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAutomatic];
//    vc.tabBarItem.selectedImage = [[UIImage imageNamed:[imageName stringByAppendingString:@"_selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
