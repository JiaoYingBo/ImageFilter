//
//  IFEditView.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/14.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFEditView.h"

@implementation IFEditView

+ (instancetype)createView {
    IFEditView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.slider setThumbImage:[UIImage imageNamed:@"if_slider"] forState:UIControlStateNormal];
}

#pragma mark - actions

- (IBAction)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editView:didClickedButton:)]) {
        [self.delegate editView:self didClickedButton:sender];
    }
}

- (IBAction)valueChanged:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(editView:sliderValueDidChanged:)]) {
        [self.delegate editView:self sliderValueDidChanged:sender.value];
    }
}

@end
