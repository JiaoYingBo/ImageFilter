//
//  IFImageCollectionCell.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/13.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFTextView.h"

@interface IFImageCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IFTextView *textView;
@property (nonatomic, copy) void(^textMoveEnded)(IFImageCollectionCell *cell);

@end
