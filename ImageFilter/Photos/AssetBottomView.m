//
//  AssetBottomView.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "AssetBottomView.h"
#import "AssetSelectionUtil.h"

@interface AssetBottomView ()

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *completionBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property (nonatomic, strong) UIColor *cmpBtnColor;

@end

@implementation AssetBottomView

+ (instancetype)createView {
    AssetBottomView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    view.themeStyle = ASThemeStyleDark;
    view.countLabel.layer.cornerRadius = 10;
    view.countLabel.layer.masksToBounds = YES;
    view.countLabel.hidden = YES;
    view.cmpBtnColor = view.completionBtn.titleLabel.textColor;
    view.count = 0;
    return view;
}

#pragma mark - setter

- (void)setThemeStyle:(ASThemeStyle)themeStyle {
    _themeStyle = themeStyle;
    
    if (themeStyle == ASThemeStyleLight) {
        self.line.hidden = NO;
        self.lineHeight.constant = 1.0/[UIScreen mainScreen].scale;
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.line.hidden = YES;
        self.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.9];
    }
}

- (void)setCount:(NSUInteger)count {
    _count = count;
    
    if (count == 0) {
        self.countLabel.hidden = YES;
        
        self.completionBtn.enabled = NO;
        [self.completionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"%td", count];
        
        self.completionBtn.enabled = YES;
        [self.completionBtn setTitleColor:self.cmpBtnColor forState:UIControlStateNormal];
        
        self.countLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
            self.countLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)setCompletionBtnEnabled:(BOOL)completionBtnEnabled {
    _completionBtnEnabled = completionBtnEnabled;
    self.completionBtn.enabled = _completionBtnEnabled;
}

#pragma mark - actions

- (IBAction)completionClick:(UIButton *)sender {
    sender.enabled = NO;
    
    if (self.completionBtnClick) {
        if (self.completionBtnClick()) {
            [[AssetSelectionUtil sharedUtil] clear];
        } else {
            sender.enabled = YES;
        }
    }
}

@end
