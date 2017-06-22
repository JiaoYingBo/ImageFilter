//
//  ParameterAdjustmentView.h
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScalarFilterParameter.h"
#import "LabeledSliderView.h"
#import "ParameterAdjustmentDelegate.h"

@interface ParameterAdjustmentView : UIView

@property (nonatomic, strong) NSArray<ScalarFilterParameter *> *parameters;
@property (nonatomic, strong) NSMutableArray *sliderViews;

- (instancetype)initWithFrame:(CGRect)frame parameters:(NSArray *)parameters;
- (void)setAdjustmentDelegate:(id<ParameterAdjustmentDelegate>)delegate;

@end
