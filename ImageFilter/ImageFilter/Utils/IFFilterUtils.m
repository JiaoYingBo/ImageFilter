//
//  IFFilterUtils.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/4.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFFilterUtils.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
//#import <GPUImage.h>
#import "IFImagePropertyModel.h"
#import "IFColorMatrix.h"

@implementation IFFilterUtils

// 滤镜列表-->亮度、对比度、饱和度-->色温
+ (void)processImage:(UIImage *)image withProperty:(IFImagePropertyModel *)model completion:(void(^)(UIImage *image))completion {
    // CoreImage滤镜效果
    [self filterImage:image withFilter:[[self filterArray] objectAtIndex:model.selectedFilterIndex] completion:^(UIImage *img) {
//        [self filterImage:img withProperty:model completion:^(UIImage *image) {
            if (completion) {
                completion(image);
            }
//        }];
    }];
    
    // OpenGL滤镜效果
//    NSInteger index = model.selectedFilterIndex;
//    UIImage *img = index == 0 ? image : [self imageWithImage:image withColorMatrix:[self matrixWithIndex:index]];
//    [self filterImage:img withProperty:model completion:^(UIImage *image) {
//        if (completion) {
//            completion(image);
//        }
//    }];
}

// 同时设置 亮度、对比度、饱和度、色温
//+ (void)filterImage:(UIImage *)image withProperty:(IFImagePropertyModel *)model completion:(void(^)(UIImage *image))completion {
//    [self brightnessWithValue:model.brightnessValue image:image completion:^(UIImage *image) {
//        [self contrastWithValue:model.contrastValue image:image completion:^(UIImage *image) {
//            [self vibranceWithValue:model.saturationValue image:image completion:^(UIImage *image) {
//                [self whiteBalanceWithValue:model.colorTemperatureValue image:image completion:^(UIImage *image) {
//                    if (completion) {
//                        completion(image);
//                    }
//                }];
//            }];
//        }];
//    }];
//}

// 同时设置 亮度、对比度、饱和度
+ (void)filterWithImage:(UIImage *)image BrightnessValue:(CGFloat)v1 contrastValue:(CGFloat)v2 saturationValue:(CGFloat)v3 completion:(void(^)(UIImage *image))block {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
        [filter setValue:beginImage forKey:kCIInputImageKey];
        //  亮度
        [filter setValue:@(v1) forKey:kCIInputBrightnessKey];
        //  对比度
        [filter setValue:@(v2) forKey:kCIInputContrastKey];
        //  饱和度
        [filter setValue:@(v3) forKey:kCIInputSaturationKey];
        // 得到过滤后的图片
        CIImage *outputImage = [filter outputImage];
        // 转换图片, 创建基于GPU的CIContext对象
        CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@(YES)}];//CPU渲染
        //        CIContext *context = [CIContext contextWithOptions: nil];
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (block) {
                block(newImg);
            }
        });
    });
}

// GPUImage设置色温  temperature：1000到10000，默认5000   tint：-1000到1000，默认0
//+ (void)whiteBalanceWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block {
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_async(queue, ^{
//        
//        GPUImageWhiteBalanceFilter *filter = [[GPUImageWhiteBalanceFilter alloc] init];
//        filter.temperature = value;
//        filter.tint = 0;
//        
//        UIImage *img = [self processImageWithFilter:filter image:image];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            if (block) {
//                block(img);
//            }
//        });
//    });
//}

#pragma mark - CoreImage滤镜
// Chrome铬黄 Fade褪色 Instant怀旧 Mono单色 Noir黑白 Process冲印 Tonal色调 Transfer岁月

+ (NSArray *)filterNameArray {
//    return @[@"原图",@"lomo",@"黑白",@"怀旧",@"哥特",@"淡雅",@"酒红",@"清宁",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色"];//OpenGL滤镜效果
        return @[@"原图",@"铬黄",@"褪色",@"怀旧",@"Curve",@"单色",@"冲印",@"色调",@"岁月",@"黑白"];//CoreImage滤镜效果
};

+ (NSArray *)filterArray {
    return @[@"Original",@"CIPhotoEffectChrome",@"CIPhotoEffectFade",@"CIPhotoEffectInstant",@"CILinearToSRGBToneCurve",@"CIPhotoEffectMono",@"CIPhotoEffectProcess",@"CIPhotoEffectTonal",@"CIPhotoEffectTransfer",@"CIPhotoEffectNoir"];//CoreImage滤镜效果
}

// 滤镜效果  快速滑动时这个方法极容易崩溃！！！！！！！！！！！！！！！！
+ (void)filterImage:(UIImage *)image withFilter:(NSString *)filter completion:(void(^)(UIImage *image))completionHandler {
    if ([filter isEqualToString:@"Original"]) {
        if (completionHandler) {
            completionHandler(image);
        }
        return;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
        CIFilter *ciFilter = [CIFilter filterWithName:filter keysAndValues:kCIInputImageKey, ciImage, nil];
        [ciFilter setDefaults];

        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [ciFilter outputImage];
        CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *effetImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);

        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(effetImage);
            }
        });
    });
}

// CoreImage设置色温
+ (void)whiteBalanceWithValue1:(CGFloat)v1 value2:(CGFloat)v2 image:(UIImage *)image completion:(void(^)(UIImage *image))block {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        CIFilter *yourFilter = [CIFilter filterWithName:@"CITemperatureAndTint"];
        [yourFilter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:kCIInputImageKey];
        [yourFilter setValue:[CIVector vectorWithX:v1 Y:0] forKey:@"inputNeutral"]; // Default value: [6500, 0]
        [yourFilter setValue:[CIVector vectorWithX:v2 Y:0] forKey:@"inputTargetNeutral"]; // Default value: [6500, 0]
        CIImage *resultImage = [yourFilter outputImage];
        CIContext *context = [CIContext contextWithOptions: nil];
        CGImageRef cgimg = [context createCGImage:resultImage fromRect:[resultImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (block) {
                block(newImg);
            }
        });
    });
}

// 亮度、对比度、饱和度
+ (void)filterWithProperty:(IFImagePropertyModel *)model image:(UIImage *)image completion:(void(^)(UIImage *image))block {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
        [filter setValue:beginImage forKey:kCIInputImageKey];
        NSLog(@"%f  %f  %f",model.brightnessValue,model.contrastValue,model.saturationValue);
        //  饱和度      0---2
        [filter setValue:@(model.saturationValue) forKey:@"inputSaturation"];
        //  亮度  10   -1---1
        [filter setValue:@(model.brightnessValue) forKey:@"inputBrightness"];
        //  对比度 -11  0---4
        [filter setValue:@(model.contrastValue) forKey:@"inputContrast"];
        // 得到过滤后的图片
        CIImage *outputImage = [filter outputImage];
        // 转换图片, 创建基于GPU的CIContext对象
        CIContext *context = [CIContext contextWithOptions: nil];
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (block) {
                block(newImg);
            }
        });
    });
}

// 亮度 -1.0到1.0，默认0
//+ (void)brightnessWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block {
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_async(queue, ^{
//        
//        GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
//        filter.brightness = value;
//        
//        UIImage *img = [self processImageWithFilter:filter image:image];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//            if (block) {
//                block(img);
//            }
//        });
//    });
//}

// 对比度 0.0到4.0，默认1
//+ (void)contrastWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block {
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_async(queue, ^{
//        
//        GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init];
//        filter.contrast = value;
//        
//        UIImage *img = [self processImageWithFilter:filter image:image];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//            if (block) {
//                block(img);
//            }
//        });
//    });
//}

// 锐化 -4.0到4.0，默认0
//+ (void)sharpenWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block {
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_async(queue, ^{
//        
//        GPUImageSharpenFilter *filter = [[GPUImageSharpenFilter alloc] init];
//        filter.sharpness = value;
//        
//        UIImage *img = [self processImageWithFilter:filter image:image];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//            if (block) {
//                block(img);
//            }
//        });
//    });
//}

// 饱和度 0到2.0，默认1.0
//+ (void)vibranceWithValue:(CGFloat)value image:(UIImage *)image completion:(void(^)(UIImage *image))block {
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_async(queue, ^{
//        
//        GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init];
//        filter.saturation = value;
//        
//        UIImage *img = [self processImageWithFilter:filter image:image];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//            if (block) {
//                block(img);
//            }
//        });
//    });
//}

//+ (UIImage *)processImageWithFilter:(GPUImageFilter *)filter image:(UIImage *)image{
//    GPUImagePicture *picProcess = [[GPUImagePicture alloc] initWithImage:image];
//    [picProcess addTarget:filter];
//    [filter useNextFrameForImageCapture];
//    [picProcess processImage];
//    return [filter imageFromCurrentFramebuffer];
//}

#pragma mark - OpenGL图形处理

static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)// 返回一个使用RGBA通道的位图上下文
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage); //纵向
    
    bitmapBytesPerRow = (int)(pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount	= (int)(bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    
    bitmapData = malloc(bitmapByteCount); //分配足够容纳图片字节数的内存空间
    
    context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    
    CGColorSpaceRelease( colorSpace );
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    
    return context;
}

static unsigned char *RequestImagePixelData(UIImage *inImage)
// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    
    CGContextRef cgctx = CreateRGBABitmapContext(img); //使用上面的函数创建上下文
    
    CGRect rect = {{0,0},{size.width, size.height}};
    
    CGContextDrawImage(cgctx, rect, img); //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    unsigned char *data = CGBitmapContextGetData (cgctx);
    
    CGContextRelease(cgctx);//释放上面的函数创建的上下文
    return data;
}

static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f)//修改RGB的值
{
    int redV = *red;
    int greenV = *green;
    int blueV = *blue;
    int alphaV = *alpha;
    
    *red = f[0] * redV + f[1] * greenV + f[2] * blueV + f[3] * alphaV + f[4];
    *green = f[0+5] * redV + f[1+5] * greenV + f[2+5] * blueV + f[3+5] * alphaV + f[4+5];
    *blue = f[0+5*2] * redV + f[1+5*2] * greenV + f[2+5*2] * blueV + f[3+5*2] * alphaV + f[4+5*2];
    *alpha = f[0+5*3] * redV + f[1+5*3] * greenV + f[2+5*3] * blueV + f[3+5*3] * alphaV + f[4+5*3];
    
    if (*red > 255)
    {
        *red = 255;
    }
    if(*red < 0)
    {
        *red = 0;
    }
    if (*green > 255)
    {
        *green = 255;
    }
    if (*green < 0)
    {
        *green = 0;
    }
    if (*blue > 255)
    {
        *blue = 255;
    }
    if (*blue < 0)
    {
        *blue = 0;
    }
    if (*alpha > 255)
    {
        *alpha = 255;
    }
    if (*alpha < 0)
    {
        *alpha = 0;
    }
}

+ (UIImage*)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)matrix
{
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    CGImageRef inImageRef = [inImage CGImage];
    GLuint w = (unsigned int)CGImageGetWidth(inImageRef);
    GLuint h = (unsigned int)CGImageGetHeight(inImageRef);
    
    int wOff = 0;
    int pixOff = 0;
    
    
    for(GLuint y = 0;y< h;y++)//双层循环按照长宽的像素个数迭代每个像素点
    {
        pixOff = wOff;
        
        for (GLuint x = 0; x<w; x++)
        {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha = (unsigned char)imgPixel[pixOff+3];
            changeRGBA(&red, &green, &blue, &alpha, matrix);
            
            //回写数据
            imgPixel[pixOff] = red;
            imgPixel[pixOff+1] = green;
            imgPixel[pixOff+2] = blue;
            imgPixel[pixOff+3] = alpha;
            
            
            pixOff += 4; //将数组的索引指向下四个元素
        }
        
        wOff += w * 4;
    }
    
    NSInteger dataLength = w * h * 4;
    
    //下面的代码创建要输出的图像的相关参数
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    
    CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow,colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);//创建要输出的图像
    
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return myImage;
}

+ (const float*)matrixWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return NULL;
            break;
        case 1:
            return colormatrix_lomo;
            break;
        case 2:
            return colormatrix_heibai;
            break;
        case 3:
            return colormatrix_huaijiu;
            break;
        case 4:
            return colormatrix_gete;
            break;
        case 5:
            return colormatrix_danya;
            break;
        case 6:
            return colormatrix_jiuhong;
            break;
        case 7:
            return colormatrix_qingning;
            break;
        case 8:
            return colormatrix_langman;
            break;
        case 9:
            return colormatrix_guangyun;
            break;
        case 10:
            return colormatrix_landiao;
            break;
        case 11:
            return colormatrix_menghuan;
            break;
        case 12:
            return colormatrix_yese;
            break;
            
        default:
            return NULL;
            break;
    }
}


@end
