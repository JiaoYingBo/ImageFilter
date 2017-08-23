//
//  VideoBottomView.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/6/1.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "VideoBottomView.h"

@implementation VideoBottomView {
    __weak IBOutlet UIButton *completionBtn;
}

+ (instancetype)createView {
    VideoBottomView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    view.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.9];
    return view;
}

- (void)setCompletionBtnEnabled:(BOOL)completionBtnEnabled {
    _completionBtnEnabled = completionBtnEnabled;
    completionBtn.enabled = completionBtnEnabled;
}

- (IBAction)completionBtnClick:(UIButton *)sender {
    if (self.completionBtnClick) {
        self.completionBtnClick();
    }
    sender.enabled = NO;
}

@end
