//
//  IFImageEditorController.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/2.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFImageEditorController.h"
#import "IFEditorViewController.h"

@interface IFImageEditorController ()<IFEditorViewControllerDelegate>
{
    UIStatusBarStyle _originStatusBarStyle;
    UIColor *_originStatusBarColor;
}

//@property (nonatomic, weak) IFEditorViewController *editor;

@end

@implementation IFImageEditorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarStyle];
    [self setupControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    _originStatusBarColor = [self getStatusBarBackgroundColor];
//    [self setStatusBarBackgroundColor:nil];
//    [self setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self setStatusBarHidden:NO];
//    [UIApplication sharedApplication].statusBarStyle = _originStatusBarStyle;
//    [self setStatusBarBackgroundColor:_originStatusBarColor];
}

#pragma mark - setter

- (void)setSelectIndex:(NSUInteger)selectIndex {
    _selectIndex = selectIndex;
    
}

#pragma mark - delegate

- (void)editorViewController:(IFEditorViewController *)editorController processedImages:(NSArray<UIImage *> *)images {
    if ([self.editorDelegate respondsToSelector:@selector(imageEditorController:processedImages:)]) {
        [self.editorDelegate imageEditorController:self processedImages:images];
    }
}

#pragma mark - set style

- (void)setupControllers {
    IFEditorViewController *editor = [[IFEditorViewController alloc] init];
    editor.selectIndex = self.selectIndex;
    editor.delegate = self;
    editor.navigationItem.title = @"编辑图片";
    editor.originalImagesArray = self.originalImagesArray;
    [self setViewControllers:@[editor] animated:NO];
}

- (void)setNavigationBarStyle {
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationBar.translucent = YES;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationBar.hidden = YES;
}

//- (void)setStatusBarBackgroundColor:(UIColor *)color {
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
//}
//
//- (void)setStatusBarHidden:(BOOL)hidden {
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    [statusBar setHidden:hidden];
//}
//
//- (UIColor *)getStatusBarBackgroundColor {
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    return statusBar.backgroundColor;
//}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
