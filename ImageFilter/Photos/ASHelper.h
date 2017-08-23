//
//  ASHelper.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/6/1.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#ifndef ASHelper_h
#define ASHelper_h

#ifdef __OBJC__

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

typedef NS_ENUM(NSInteger, ASFetchMediaType) {
    ASFetchMediaTypeDefault = 0, //视频+图片
    ASFetchMediaTypeImage,   //图片
    ASFetchMediaTypeVideo    //视频
};


#endif

#endif /* ASHelper_h */
