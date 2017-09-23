//
//  IFTextView.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/4.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFTextView.h"
#import "IFTextUtils.h"

@implementation IFTextView {
    UIView *_inner;
    UIButton *_delete;
    UIButton *_circle;
    BOOL _isCircle;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        _isCircle = NO;
        [self setBorderHidden:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IFTextViewTouchEnd" object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _inner.frame = CGRectInset(self.bounds, 10, 10);
    // Label距离self前后各20，上下各10
//    _titleLabel.frame = CGRectMake(20, 10, self.bounds.size.width - 40, self.bounds.size.height-20);
    _circle.frame = CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 20, 20);
}

- (void)setupUI {
    UIView *innerView = [[UIView alloc] init];
    innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:innerView];
    innerView.layer.borderColor = [UIColor whiteColor].CGColor;
    innerView.layer.borderWidth = 1;
    _inner = innerView;
    
//    _delete = [UIButton buttonWithType:UIButtonTypeCustom];
//    _delete.frame = CGRectMake(0, 0, 20, 20);
//    [_delete setImage:[UIImage imageNamed:@"ZoomingViewDelete"] forState:UIControlStateNormal];
//    [_delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_delete];
//    
//    _circle = [UIButton buttonWithType:UIButtonTypeCustom];
//    _circle.userInteractionEnabled = NO;
//    [_circle setImage:[UIImage imageNamed:@"ZoomingViewCircle"] forState:UIControlStateNormal];
//    [self addSubview:_circle];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.numberOfLines = 0;
//    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_titleLabel];
    
}

- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = text;
    if (self.setText) {
        self.setText(self);
    }
    
    CGFloat width = [IFTextUtils getWidthWithContent:text height:30 font:18];
    if (width <= 280) {
        CGSize size = [IFTextUtils getSizeWithContent:text font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(280, 100)];
        self.titleLabel.bounds = CGRectMake(0, 0, size.width, size.height);
        self.titleLabel.center = CGPointMake(size.width/2+20, self.bounds.size.height/2);
        self.bounds = CGRectMake(0, 0, width + 40, 50);
        [self layoutIfNeeded];
    } else {
        CGFloat height = [IFTextUtils getHeightWithContent:text width:280 font:18];
        self.bounds = CGRectMake(0, 0, 280 + 40, height + 20);
    }
}

- (void)setBorderHidden:(BOOL)hidden {
    if (hidden) {
        _inner.hidden = YES;
        self.userInteractionEnabled = NO;
    } else {
        _inner.hidden = NO;
        self.userInteractionEnabled = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if ([[event allTouches] count] > 1) {
        return;//多个手指不执行
    }
    
    if (CGRectContainsPoint(_circle.frame, point)) {
//        _isCircle = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IFTextViewTouchBegin" object:nil];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:touch.view];//当前手指的坐标
    CGPoint previousPoint = [touch previousLocationInView:touch.view];//上一个坐标
    
    if (_isCircle) {
        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        CGFloat angle = atan2f(currentPoint.y - center.y, currentPoint.x - center.x) - atan2f(previousPoint.y - center.y, previousPoint.x - center.x);
        self.transform = CGAffineTransformRotate(self.transform, angle);
    } else {
        self.transform = CGAffineTransformTranslate(self.transform, currentPoint.x-previousPoint.x, currentPoint.y-previousPoint.y);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IFTextViewTouchEnd" object:nil];
    _isCircle = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IFTextViewTouchEnd" object:nil];
    _isCircle = NO;
}

#pragma mark - actions

- (void)delete {
    NSLog(@"delete");
}

@end
