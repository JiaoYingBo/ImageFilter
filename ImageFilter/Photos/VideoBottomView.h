//
//  VideoBottomView.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/6/1.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoBottomView : UIView

@property (nonatomic, copy) void(^completionBtnClick)(void);
@property (nonatomic, assign) BOOL completionBtnEnabled;

+ (instancetype)createView;

@end
