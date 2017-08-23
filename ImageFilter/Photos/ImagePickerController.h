//
//  ImagePickerController.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/29.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "AppearanceController.h"
#import "ASHelper.h"

@class ImagePickerController;
@protocol ImagePickerControllerDelegate <NSObject>

@optional
// 图片回调，thumbImage分辨率100*100
- (void)imagePickerController:(ImagePickerController *)controller disFinishPickingThumbImages:(NSArray<UIImage *> *)thumbImages originalImages:(NSArray<UIImage *> *)originalImages infos:(NSArray<NSDictionary *> *)infos;

// 视频回调
- (void)imagePickerController:(ImagePickerController *)controller didFinishPickingVideoPath:(NSString *)path coverImage:(UIImage *)image;

@end

@interface ImagePickerController : AppearanceController

@property (nonatomic, weak) id<ImagePickerControllerDelegate> pickerDelegate;
// 可选图片张数，默认9张
@property (nonatomic, assign) NSUInteger maxImagesCount;
// 选择类型(照片或视频)
@property (nonatomic, assign) ASFetchMediaType mediaType;

/*
 获取照片和视频的接口开放出来是很不好的做法，注意后期优化！
 */
- (void)downloadImages;
- (void)downloadVideo;

@end
