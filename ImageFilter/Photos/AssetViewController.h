//
//  AssetViewController.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "BaseController.h"
#import <Photos/Photos.h>
//#import <PhotosUI/PhotosUI.h>

@interface AssetViewController : BaseController

//@property (nonatomic, assign) NSInteger photoCount;
//@property (nonatomic, strong) PHAsset *asset;
//@property (nonatomic, strong) PHAssetCollection *assetCollection;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
