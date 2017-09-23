//
//  IFEditImageController.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/14.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFBaseViewController.h"
#import "IFEditImageView.h"
#import "IFEditView.h"
#import "IFImageEditor.h"

@class IFEditImageController, IFImagePropertyModel;
@protocol IFEditImageControllerDelegate <NSObject>

@optional
// 确认按钮点击回调
- (void)editImageController:(IFEditImageController *)editController didProcessedImage:(UIImage *)image property:(IFImagePropertyModel *)model originalCuttedImage:(UIImage *)oriCuttedImg;

@end

@interface IFEditImageController : IFBaseViewController

@property (nonatomic, weak) id<IFEditImageControllerDelegate> delegate;

// 显示图片view
@property (nonatomic, strong) IFEditImageView *editImageView;
// 编辑栏view
@property (nonatomic, strong) IFEditView *editView;

// 显示的图片
@property (nonatomic, strong) UIImage *image;
// 被处理的图片
@property (nonatomic, strong) UIImage *processedImage;
// 编辑类型
@property (nonatomic, assign) IFEditType editType;
// 图片属性
@property (nonatomic, strong) IFImagePropertyModel *model;
// “取消”“继续”按钮点击回调
@property (nonatomic, copy) void(^navBtnClick)(NSInteger tag);

@end
