//
//  IFImageUtils.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/4.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFImageUtils : NSObject

// 将图片转换为指定尺寸大小
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
// 将文字添加到图片上
+ (UIImage *)redrawImageWith:(UIImage *)image text:(NSString *)text frame:(CGRect)frame scale:(CGFloat)scale;
// 将图片添加到图片上
+ (UIImage *)redrawImageWithbottomImage:(UIImage *)bImage topImage:(UIImage *)tImage frame:(CGRect)frame scale:(CGFloat)scale;
// 剪裁图片
+ (UIImage *)cutImage:(UIImage *)image withRect:(CGRect)rect;

@end
