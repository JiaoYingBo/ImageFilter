//
//  AssetSelectionUtil.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "ASHelper.h"

@interface AssetSelectionUtil : NSObject

// 显示照片还是视频
@property (nonatomic, assign) ASFetchMediaType mediaType;
// 正在加载高清图的照片（可能是正在从iCloud下载）
@property (nonatomic, strong) NSMutableArray *downloadingImages;
// 照片选择
@property (nonatomic, strong) NSMutableArray *selectedPhotoIndexes;
@property (nonatomic, assign) NSUInteger maxImagesCount;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;
// 视频选择
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) PHAsset *videoAsset;

// 单例初始化
+ (instancetype)sharedUtil;
// 清除所有记录的数据
- (void)clear;
// 秒数转换时间
- (NSString *)timeFormat:(NSUInteger)totalSeconds;

@end
