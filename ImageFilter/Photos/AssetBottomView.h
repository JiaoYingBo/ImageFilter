//
//  AssetBottomView.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ASThemeStyle) {
    ASThemeStyleDark,
    ASThemeStyleLight
};

@interface AssetBottomView : UIView

@property (nonatomic, assign) ASThemeStyle themeStyle;
@property (nonatomic, copy) BOOL(^completionBtnClick)(void);

@property (nonatomic, assign) BOOL completionBtnEnabled;
@property (nonatomic, assign) NSUInteger count;

+ (instancetype)createView;

@end
