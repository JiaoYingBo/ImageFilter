//
//  ParameterAdjustmentDelegate.h
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParameterAdjustmentDelegate <NSObject>
@optional
- (void)parameterValueDidChange:(ScalarFilterParameter *)param;

@end
