//
//  IFFilterUtils.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/4.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFImageEditor.h"

@class IFImagePropertyModel;
@interface IFFilterUtils : NSObject

// 滤镜名字
+ (NSArray *)filterNameArray;
// 滤镜
+ (NSArray *)filterArray;
// 滤镜矩阵
+ (const float*)matrixWithIndex:(NSInteger)index;
// 滤镜效果(OpenGL，内存泄漏非常严重，怎么滤镜效果没有一个靠谱的！)
+ (UIImage *)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)matrix;
// 滤镜效果(CoreImage 容易崩溃)
+ (void)filterImage:(UIImage *)image withFilter:(NSString *)filter completion:(void(^)(UIImage *image))completionHandler;
// 亮度、对比度、饱和度、色温 同时调节
//+ (void)filterImage:(UIImage *)image withProperty:(IFImagePropertyModel *)model completion:(void(^)(UIImage *image))completion;
// 滤镜列表-->亮度、对比度、饱和度-->色温
+ (void)processImage:(UIImage *)image withProperty:(IFImagePropertyModel *)model completion:(void(^)(UIImage *image))completion;

/******************** 以下方法暂时废弃 ********************/
// 亮度、对比度、饱和度 同时调节
//+ (void)filterWithProperty:(IFImagePropertyModel *)model image:(UIImage *)image completion:(void(^)(UIImage *image))block;
//// 亮度
//+ (void)brightnessWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block;
//// 对比度
//+ (void)contrastWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block;
//// 锐化
//+ (void)sharpenWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block;
//// 饱和度
//+ (void)vibranceWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block;
//// 色温（白平衡）
//+ (void)whiteBalanceWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block;

@end
