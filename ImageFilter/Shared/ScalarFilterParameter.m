//
//  ScalarFilterParameter.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "ScalarFilterParameter.h"

@implementation ScalarFilterParameter

- (instancetype)initWithKey:(NSString *)key value:(CGFloat)value {
    if (self = [super init]) {
        self.key = key;
        self.currentValue = value;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name key:(NSString *)key minimumValue:(CGFloat)min maximumValue:(CGFloat)max currentValue:(CGFloat)current {
    if (self = [super init]) {
        self.name = name;
        self.key = key;
        self.minimumValue = min;
        self.maximumValue = max;
        self.currentValue = current;
    }
    return self;
}

@end
