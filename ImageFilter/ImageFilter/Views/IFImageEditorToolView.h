//
//  IFImageEditorToolView.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/13.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFImageEditorToolView, IFImagePropertyModel;
@protocol IFImageEditorToolViewDelegate <NSObject>

@optional
// 滤镜处理完毕
- (void)imageEditorToolView:(IFImageEditorToolView *)editor didProcessedImage:(UIImage *)image property:(IFImagePropertyModel *)model;
// 编辑按钮点击
- (void)imageEditorToolView:(IFImageEditorToolView *)editor didClickedEditButton:(UIButton *)button;

@end

@interface IFImageEditorToolView : UIView

@property (nonatomic, weak) id<IFImageEditorToolViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *selectedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linePositionX;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScroll;
@property (weak, nonatomic) IBOutlet UIButton *filterLibraryBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautifyPictureBtn;
@property (weak, nonatomic) IBOutlet UIView *filterLibraryView;
@property (weak, nonatomic) IBOutlet UIView *beautifyPictureView;
@property (weak, nonatomic) IBOutlet UIButton *activityStickerBtn;
@property (weak, nonatomic) IBOutlet UIButton *myStickerBtn;
@property (weak, nonatomic) IBOutlet UIView *activityStickerView;
@property (weak, nonatomic) IBOutlet UIView *myStickerView;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;

// 显示的图片
@property (nonatomic, strong) UIImage *originalImage;
// 被处理的图片
@property (nonatomic, strong) UIImage *processedImage;
// 处理属性
@property (nonatomic, strong) IFImagePropertyModel *model;

+ (instancetype)createView;

@end
