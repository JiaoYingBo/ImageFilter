//
//  AssetTopView.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "AssetTopView.h"

@interface AssetTopView ()

@end

@implementation AssetTopView

+ (instancetype)createView {
    AssetTopView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    view.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    view.selectBtn.selected = NO;
    return view;
}

#pragma mark - actions

- (IBAction)back:(UIButton *)sender {
    if (self.backBtnClick) {
        self.backBtnClick();
    }
}

- (IBAction)selectBtn:(UIButton *)sender {
    if (self.selectBtnClick) {
        if (!self.selectBtnClick(!sender.selected)) { return; }
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"as_photo_sel_big"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"as_photo_def"] forState:UIControlStateNormal];
    }
}

#pragma mark - public method

- (void)setSelectButtonSelected:(BOOL)selected {
    if (selected) {
        [self.selectBtn setImage:[UIImage imageNamed:@"as_photo_sel_big"] forState:UIControlStateNormal];
    } else {
        [self.selectBtn setImage:[UIImage imageNamed:@"as_photo_def"] forState:UIControlStateNormal];
    }
    
    self.selectBtn.selected = selected;
//    if (self.selectBtnClick) {
//        self.selectBtnClick(self.selectBtn.selected);
//    }
}

@end
