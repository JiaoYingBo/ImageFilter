//
//  ParameterAdjustmentView.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "ParameterAdjustmentView.h"

#define kSliderMarginX 20
#define kSliderMarginY 8
#define kSliderHeight 48

@implementation ParameterAdjustmentView

- (instancetype)initWithFrame:(CGRect)frame parameters:(NSArray *)parameters {
    if (self = [super initWithFrame:frame]) {
        self.parameters = parameters;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    CGFloat yOffset = kSliderMarginY;
    for (ScalarFilterParameter *param in self.parameters) {
        
        CGRect frame = CGRectMake(0, yOffset, self.bounds.size.width, kSliderHeight);
        
        LabeledSliderView *sliderView = [[LabeledSliderView alloc] initWithFrame:frame parameter:param];
        sliderView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:sliderView];
        
        [self.sliderViews addObject:sliderView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:sliderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:kSliderMarginX]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:sliderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:yOffset]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:sliderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-kSliderMarginX * 2]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:sliderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:kSliderHeight]];
        
        yOffset += (kSliderHeight + kSliderMarginY);
    }
}

- (void)setAdjustmentDelegate:(id<ParameterAdjustmentDelegate>)delegate {
    for (LabeledSliderView *slider in self.sliderViews) {
        slider.delegate = delegate;
    }
}

- (NSMutableArray *)sliderViews {
    if (!_sliderViews) {
        _sliderViews = [NSMutableArray array];
    }
    return _sliderViews;
}

@end
