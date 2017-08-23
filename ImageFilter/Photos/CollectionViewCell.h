//
//  CollectionViewCell.h
//  CollectionViewPhoto
//
//  Created by Mac on 16/4/19.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, copy) BOOL(^selectBtnClick)(BOOL isSelected);
@property (nonatomic, assign) BOOL select;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
// 视频时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 视频标志view
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
