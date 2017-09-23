//
//  IFTextUtils.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/4.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFTextUtils : NSObject

+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font;
+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font;
+ (CGSize)getSizeWithContent:(NSString *)content font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
