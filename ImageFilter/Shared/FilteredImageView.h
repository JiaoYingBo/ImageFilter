//
//  FilteredImageView.h
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "ParameterAdjustmentView.h"

@interface FilteredImageView : GLKView <ParameterAdjustmentDelegate>

@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) UIImage *inputImage;

@end
