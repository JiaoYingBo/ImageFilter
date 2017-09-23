//
//  IFImageUtils.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/4.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFImageUtils.h"

@implementation IFImageUtils

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        } else {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

// 将文字添加到图片上
+ (UIImage *)redrawImageWith:(UIImage *)image text:(NSString *)text frame:(CGRect)frame scale:(CGFloat)scale {
    UIFont *font = [UIFont systemFontOfSize:18 * scale];
    NSDictionary *dict = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGSize textSize = [text sizeWithAttributes:dict];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGRect rect = {CGPointMake(frame.origin.x * scale, frame.origin.y * scale), CGSizeMake(textSize.width * scale, textSize.height * scale)};
    [text drawInRect:rect withAttributes:dict];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)redrawImageWithbottomImage:(UIImage *)bImage topImage:(UIImage *)tImage frame:(CGRect)frame scale:(CGFloat)scale {
    UIGraphicsBeginImageContext(bImage.size);
    
    [bImage drawInRect:CGRectMake(0, 0, bImage.size.width, bImage.size.height)];
    [tImage drawInRect:CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width * scale, frame.size.height * scale)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)cutImage:(UIImage *)image withRect:(CGRect)rect {
    if (rect.size.height == 0) {
        return nil;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}


@end
