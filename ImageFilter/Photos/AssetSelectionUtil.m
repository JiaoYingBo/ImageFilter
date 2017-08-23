//
//  AssetSelectionUtil.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "AssetSelectionUtil.h"

@implementation AssetSelectionUtil

static id util = nil;

+ (instancetype)sharedUtil {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[AssetSelectionUtil alloc] init];
    });
    return util;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!util) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            util = [super allocWithZone:zone];
        });
    }
    return util;
}

#pragma mark - public method

- (void)clear {
    [self.selectedPhotoIndexes removeAllObjects];
    
}

- (NSString *)timeFormat:(NSUInteger)totalSeconds {
    NSUInteger seconds = totalSeconds % 60;
    NSUInteger minutes = (totalSeconds / 60) % 60;
    NSUInteger hours = totalSeconds / 3600;
    
    if (hours == 0) {
        return [NSString stringWithFormat:@"%02td:%02td", minutes, seconds];
    }
    return [NSString stringWithFormat:@"%02td:%02td:%02td", hours, minutes, seconds];
}

#pragma mark - setter

- (void)setFetchResult:(PHFetchResult<PHAsset *> *)fetchResult {
    _fetchResult = fetchResult;
}

#pragma mark - lazy load

- (NSMutableArray *)selectedPhotoIndexes {
    if (!_selectedPhotoIndexes) {
        _selectedPhotoIndexes = [NSMutableArray arrayWithCapacity:9];
    }
    return _selectedPhotoIndexes;
}

- (NSMutableArray *)downloadingImages {
    if (!_downloadingImages) {
        _downloadingImages = [NSMutableArray array];
    }
    return _downloadingImages;
}

@end
