//
//  IFImagePropertyModel.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/14.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFImagePropertyModel : NSObject<NSCopying>

// 滤镜效果索引值
@property (nonatomic, assign) NSUInteger selectedFilterIndex;
// 我的贴纸索引值
@property (nonatomic, assign) NSUInteger selectedMyStickerIndex;
// 活动贴纸索引值
@property (nonatomic, assign) NSUInteger selectedActivityStickerIndex;
// 亮度
@property (nonatomic, assign) CGFloat brightnessValue;
@property (nonatomic, assign) CGFloat brightnessSliderValue;
// 对比度
@property (nonatomic, assign) CGFloat contrastValue;
@property (nonatomic, assign) CGFloat contrastSliderValue;
// 色温
@property (nonatomic, assign) CGFloat colorTemperatureValue;
@property (nonatomic, assign) CGFloat colorTemperatureSliderValue;
// 饱和度
@property (nonatomic, assign) CGFloat saturationValue;
@property (nonatomic, assign) CGFloat saturationSliderValue;
// 原图（裁剪时用）
@property (nonatomic, strong) UIImage *originalImage;
// 原图+剪裁（滤镜列表用）
@property (nonatomic, strong) UIImage *cuttedOriginalImage;
// 原图+剪裁+滤镜（显示用）
@property (nonatomic, strong) UIImage *processedImage;
// 是否隐藏贴图和文字边框
@property (nonatomic, assign) BOOL borderHidden;
// 图片和视图比例
@property (nonatomic, assign) CGFloat scale;
// 文字
@property (nonatomic, strong) NSString *text;
// 文字坐标
@property (nonatomic, assign) CGRect textFrame;

@end
