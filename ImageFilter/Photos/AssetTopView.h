//
//  AssetTopView.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetTopView : UIView

@property (nonatomic, copy) void(^backBtnClick)(void);
@property (nonatomic, copy) BOOL(^selectBtnClick)(BOOL isSelected);

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

+ (instancetype)createView;
- (void)setSelectButtonSelected:(BOOL)selected;

@end
