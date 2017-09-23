//
//  IFTextViewController.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/4.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFTextViewController.h"

@interface IFTextViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation IFTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"mbl"];
    self.view.layer.contents = (id)image.CGImage;
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.textView.text = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self setStatusBarBackgroundColor:nil hiden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self setStatusBarBackgroundColor:nil hiden:NO];
}

#pragma mark - textview delegate
// 控制输入文本的长度
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location >= 20) {
        return  NO;
    }
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([[str substringToIndex:1] isEqualToString:@" "]) {
        // 首位不能为空格
        return NO;
    }
    return YES;
}

#pragma mark - actions

- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.text) {
        self.text(self.textView.text);
    }
}

#pragma mark - 修改状态栏

- (void)setStatusBarBackgroundColor:(UIColor *)color hiden:(BOOL)hiden {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
        statusBar.hidden = hiden;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
