//
//  LabeledSliderView.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "LabeledSliderView.h"

@implementation LabeledSliderView

- (instancetype)initWithFrame:(CGRect)frame parameter:(ScalarFilterParameter *)parameter {
    if (self = [super initWithFrame:frame]) {
        self.parameter = parameter;
        [self addSubviews];
        [self addLayoutConstraints];
    }
    return self;
}

- (void)addSubviews {
    self.slider = [[UISlider alloc] initWithFrame:self.frame];
    self.slider.minimumValue = self.parameter.minimumValue;
    self.slider.maximumValue = self.parameter.maximumValue;
    self.slider.value = self.parameter.currentValue;
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.slider];
    
    [self.slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont boldSystemFontOfSize:14];
    self.descriptionLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.descriptionLabel.text = self.parameter.name;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.descriptionLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.font = [UIFont boldSystemFontOfSize:14];
    self.valueLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.valueLabel.textAlignment = NSTextAlignmentRight;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", self.slider.value];
    self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.valueLabel];
}

- (void)addLayoutConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.valueLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.valueLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.valueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.valueLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
}

#pragma mark - acions

- (void)sliderTouchUpInside:(UISlider *)sender {
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
}

- (void)sliderValueDidChange:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(parameterValueDidChange:)]) {
        [self.delegate parameterValueDidChange:[[ScalarFilterParameter alloc] initWithKey:self.parameter.key value:sender.value]];
    }
}

@end
