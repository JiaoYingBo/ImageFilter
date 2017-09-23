//
//  IFImageCollectionCell.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/13.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFImageCollectionCell.h"

@implementation IFImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.userInteractionEnabled = YES;
    
    self.textView = [[IFTextView alloc] init];
    self.textView.frame = CGRectMake(0, 0, 50, 50);
    self.textView.center = self.contentView.center;
    [self.contentView addSubview:self.textView];
    CGRect frame = [self.contentView convertRect:self.textView.frame toView:self.imageView];
    self.textView.frame = frame;
    [self.contentView addSubview:self.textView];
    
    [self addObserver:self forKeyPath:@"self.imageView.image" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    NSLog(@"cell dealloc");
    [self removeObserver:self forKeyPath:@"self.imageView.image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"self.imageView.image"]) {
        
        UIImage *image = [change objectForKey:@"new"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resizeImageViewWithImage:image];
        });
    }
}

- (void)resizeImageViewWithImage:(UIImage *)image {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = width / 375.0;
    CGFloat height = width < 375 ? 370 * scale : 400 * scale;
    
    CGSize size = image.size;
    if (size.width >= size.height) {
        _imageView.frame = CGRectMake(0, 0, width, size.height / size.width * width);
    } else {
        if (size.width / size.height * height > width) {
            _imageView.frame = CGRectMake(0, 0, width, size.height / size.width * width);
        } else {
            _imageView.frame = CGRectMake(0, 0, size.width / size.height * height, height);
        }
    }
    _imageView.center = CGPointMake(width / 2, height / 2);
}

@end
