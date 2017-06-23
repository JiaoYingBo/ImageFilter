//
//  PhotoFilterCollectionViewCell.h
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/22.
//  Copyright © 2017年 YB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilteredImageView.h"

@interface PhotoFilterCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *filterNameLabel;
@property (nonatomic, strong) FilteredImageView *filteredImageView;

@end
