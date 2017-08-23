//
//  CommonTools.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/8/23.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "CommonTools.h"

@implementation CommonTools

static id _tool = nil;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[CommonTools alloc] init];
    });
    return _tool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_tool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _tool = [super allocWithZone:zone];
        });
    }
    return _tool;
}

@end
