//
//  BaseController.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/29.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "BaseController.h"
#import "AssetSelectionUtil.h"

@interface BaseController ()

@end

@implementation BaseController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    NSLog(@"====%@",self.navigationItem);
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//    self.navigationItem.backBarButtonItem = backItem;
//}
//
//- (void)backClick {
//    NSLog(@"back");
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)cancelButtonClick {
    [self dismissViewControllerAnimated:YES completion:^{
        [[AssetSelectionUtil sharedUtil] clear];
    }];
}

@end
