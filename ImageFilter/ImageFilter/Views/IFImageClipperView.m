//
//  IFImageClipperView.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/3.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFImageClipperView.h"
#import "YBPhotoCutView.h"

@interface IFImageClipperView ()<YBPhotoCutViewDelegate>

@property (nonatomic, strong) YBPhotoCutView *cutView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, assign) CGRect shotFrame;
@property (nonatomic, strong) UIImage *image;

@end

@implementation IFImageClipperView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self addSubview:self.imgView];
    [self addSubview:self.cutView];
}

#pragma mark - public method

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - YBPhotoCutView delegate

- (void)photoCutView:(YBPhotoCutView *)customView shotFrame:(CGRect)frame {
    self.shotFrame = frame;
    [self delegateInvocationWithFrame:frame];
}

- (void)delegateInvocationWithFrame:(CGRect)frame {
    if ([self.delegate respondsToSelector:@selector(imageClipperView:didClippedImage:withFrame:)]) {
        UIImage *image = [self cutImage];
        if (image) {
            [self.delegate imageClipperView:self didClippedImage:image withFrame:[self transformRect:self.shotFrame]];
        }
    }
}

#pragma mark - 图片剪裁

- (UIImage *)cutImage {
    if (self.shotFrame.size.height == 0) {
        return nil;
    }
//    double scale = self.imgView.image.size.width / self.imgView.frame.size.width;
//    CGFloat x = self.shotFrame.origin.x *scale;
//    CGFloat y = self.shotFrame.origin.y *scale;
//    CGFloat w = self.shotFrame.size.width *scale;
//    CGFloat h = self.shotFrame.size.height *scale;
    CGRect cropRect = [self transformRect:self.shotFrame];
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.imgView.image CGImage], cropRect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
//    self.shotFrame = CGRectZero;
    return img;
}

- (CGRect)transformRect:(CGRect)rect {
    double scale = self.imgView.image.size.width / self.imgView.frame.size.width;
    CGFloat x = rect.origin.x *scale;
    CGFloat y = rect.origin.y *scale;
    CGFloat w = rect.size.width *scale;
    CGFloat h = rect.size.height *scale;
    return CGRectMake(x, y, w, h);
}

#pragma mark - lazy load

- (YBPhotoCutView *)cutView {
    self.shotFrame = CGRectMake(self.bounds.size.width/4, self.bounds.size.height/4, self.bounds.size.width/2, self.bounds.size.height/2);
    if (!_cutView) {
        _cutView = [[YBPhotoCutView alloc] initWithFrame:self.bounds pictureFrame:self.shotFrame];
        _cutView.delegate = self;
        [self delegateInvocationWithFrame:self.shotFrame];
    }
    return _cutView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = self.bounds;
    }
    _imgView.image = self.image;
    return _imgView;
}

- (UIImage *)image {
    return [self.dataSource imageForimageClipperView:self];
}

@end
