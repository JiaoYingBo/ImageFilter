//
//  PhotoFilterCollectionViewCell.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/22.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "PhotoFilterCollectionViewCell.h"

#define kCellWidth 66.0
#define kLabelHeight 20.0

@implementation PhotoFilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubviews];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kCellWidth, kCellWidth + kLabelHeight);
}

- (void)addSubviews {
    [self.contentView addSubview:self.filteredImageView];
    [self.contentView addSubview:self.filterNameLabel];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.filteredImageView.layer.borderWidth = selected ? 2 : 0;
}

- (FilteredImageView *)filteredImageView {
    if (!_filteredImageView) {
        _filteredImageView = [[FilteredImageView alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellWidth)];
        _filteredImageView.layer.borderColor = self.tintColor.CGColor;
    }
    return _filteredImageView;
}

- (UILabel *)filterNameLabel {
    if (!_filterNameLabel) {
        _filterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCellWidth, kCellWidth, kLabelHeight)];
        _filterNameLabel.textAlignment = NSTextAlignmentCenter;
        _filterNameLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        _filterNameLabel.highlightedTextColor = self.tintColor;
        _filterNameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _filterNameLabel;
}

@end
