//
//  LabeledSliderView.h
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalarFilterParameter.h"
#import "ParameterAdjustmentView.h"
#import "ParameterAdjustmentDelegate.h"

@interface LabeledSliderView : UIView

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) ScalarFilterParameter *parameter;
@property (nonatomic, strong) id<ParameterAdjustmentDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame parameter:(ScalarFilterParameter *)parameter;
@end
