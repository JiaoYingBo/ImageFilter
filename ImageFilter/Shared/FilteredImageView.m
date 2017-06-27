//
//  FilteredImageView.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "FilteredImageView.h"

@interface FilteredImageView ()

@property (nonatomic, strong) CIContext *ciContext;

@end

@implementation FilteredImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame context:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]]) {
        self.clipsToBounds = YES;
        self.ciContext = [CIContext contextWithEAGLContext:self.context];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.clipsToBounds = YES;
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        self.ciContext = [CIContext contextWithEAGLContext:self.context];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.ciContext && self.inputImage && self.filter) {
        CIImage *inputCIImage = [CIImage imageWithCGImage:self.inputImage.CGImage];
        [self.filter setValue:inputCIImage forKey:kCIInputImageKey];
        
        if (self.filter.outputImage) {
            [self clearBackground];
            
            CGRect inputBounds = inputCIImage.extent;
            CGRect drawableBounds = CGRectMake(0, 0, self.drawableWidth, self.drawableHeight);
            CGRect targetBounds = [self imageBoundsForContentModeWithFromRect:inputBounds toRect:drawableBounds];
            [self.ciContext drawImage:self.filter.outputImage inRect:targetBounds fromRect:inputBounds];
        }
    }
}

- (void)clearBackground {
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    CGFloat a = 0;
    [self.backgroundColor getRed:&r green:&g blue:&b alpha:&a];
    glClearColor(r, g, b, a);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (CGRect)imageBoundsForContentModeWithFromRect:(CGRect)from toRect:(CGRect)to {
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFill:
            return [self aspectFillWithFromRect:from toRect:to];
            break;
        case UIViewContentModeScaleAspectFit:
            return [self aspectFitWithFromRect:from toRect:to];
            break;
        default:
            return from;
    }
}

- (CGRect)aspectFillWithFromRect:(CGRect)from toRect:(CGRect)to {
    CGFloat fromAspectRatio = from.size.width / from.size.height;
    CGFloat toAspectRatio = to.size.width / to.size.height;
    
    CGRect fillRect = to;
    
    if (fromAspectRatio > toAspectRatio) {
        fillRect.size.width = to.size.height  * fromAspectRatio;
        fillRect.origin.x += (to.size.width - fillRect.size.width) * 0.5;
    } else {
        fillRect.size.height = to.size.width / fromAspectRatio;
        fillRect.origin.y += (to.size.height - fillRect.size.height) * 0.5;
    }
    return fillRect;
}

- (CGRect)aspectFitWithFromRect:(CGRect)from toRect:(CGRect)to {
    CGFloat fromAspectRatio = from.size.width / from.size.height;
    CGFloat toAspectRatio = to.size.width / to.size.height;
    
    CGRect fitRect = to;
    
    if (fromAspectRatio > toAspectRatio) {
        fitRect.size.height = to.size.width / fromAspectRatio;
        fitRect.origin.y += (to.size.height - fitRect.size.height) * 0.5;
    } else {
        fitRect.size.width = to.size.height  * fromAspectRatio;
        fitRect.origin.x += (to.size.width - fitRect.size.width) * 0.5;
    }
    return fitRect;
}

#pragma mark - setter

- (void)setFilter:(CIFilter *)filter {
    _filter = filter;
    [self setNeedsDisplay];
}

- (void)setInputImage:(UIImage *)inputImage {
    _inputImage = inputImage;
    [self setNeedsDisplay];
}

#pragma mark - delegate

- (void)parameterValueDidChange:(ScalarFilterParameter *)param {
    [self.filter setValue:@(param.currentValue) forKey:param.key];
    [self setNeedsDisplay];
}

@end
