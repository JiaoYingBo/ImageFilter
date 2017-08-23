//
//  AssetCollectionCell.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "AssetCollectionCell.h"

@interface AssetCollectionCell () <UIScrollViewDelegate>

@end

@implementation AssetCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self setupUI];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    [self.scrollView setZoomScale:1.0 animated:NO];
}

- (void)setupUI {
    /**
      注意：这里的frame不要用autoresizingMask，否则scrollview的行为会很诡异！
     */
    _scrollView.frame = [UIScreen mainScreen].bounds;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.contentSize = _scrollView.bounds.size;
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.decelerationRate = 0.3;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _imageView.frame = CGRectZero;
    [_scrollView addSubview:_imageView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - setter

- (void)setImage:(UIImage *)image {
    _image = image;
    
    CGSize size = image.size;
    if (size.width >= size.height) {
        _imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height/size.width*[UIScreen mainScreen].bounds.size.width);
    } else {
        if (size.width/size.height*[UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width) {
            _imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height/size.width*[UIScreen mainScreen].bounds.size.width);
        } else {
            _imageView.frame = CGRectMake(0, 0, size.width/size.height*[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.height);
        }
    }
    _imageView.center = CGPointMake(_scrollView.bounds.size.width/2, _scrollView.bounds.size.height/2);
    _imageView.image = image;
}

#pragma mark - actions

- (void)doubleTap:(UITapGestureRecognizer *)gesture {
    if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint location = [gesture locationInView:gesture.view];
        [self.scrollView zoomToRect:CGRectMake(location.x, location.y, 1, 1) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    static CGFloat x,y;
    CGFloat centerX = scrollView.center.x;
    CGFloat centerY = scrollView.center.y;
    
    if (scrollView.zoomScale == scrollView.maximumZoomScale) {
        x = centerX;
        y = centerY;
    } else {
        centerX = x;
        centerY = y;
    }
    
    centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : centerX;
    centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : centerY;
    [self.imageView setCenter:CGPointMake(centerX, centerY)];
}

@end
