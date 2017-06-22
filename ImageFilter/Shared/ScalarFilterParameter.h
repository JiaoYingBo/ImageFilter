//
//  ScalarFilterParameter.h
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScalarFilterParameter : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, assign) CGFloat currentValue;

- (instancetype)initWithKey:(NSString *)key value:(CGFloat)value;
- (instancetype)initWithName:(NSString *)name key:(NSString *)key minimumValue:(CGFloat)min maximumValue:(CGFloat)max currentValue:(CGFloat)current;

@end
