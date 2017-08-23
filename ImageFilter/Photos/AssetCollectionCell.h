//
//  AssetCollectionCell.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetCollectionCell : UICollectionViewCell

@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void(^singleTapBlock)();

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
