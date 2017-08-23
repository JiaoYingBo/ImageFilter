//
//  PhotoController.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/29.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "BaseController.h"
#import <Photos/Photos.h>

@interface PhotoController : BaseController

@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
