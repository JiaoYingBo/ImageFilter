//
//  IFEditImageController.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/14.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFEditImageController.h"
#import "IFImageClipperView.h"
#import "IFImagePropertyModel.h"
#import "IFFilterUtils.h"
#import "IFImageUtils.h"

static CGFloat const minSpacing = 0.05;

@interface IFEditImageController () <IFEditViewDelegate, IFImageClipperViewDatasource, IFImageClipperViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 裁剪控件
@property (nonatomic, strong) IFImageClipperView *clipperView;
// 滤镜值
@property (nonatomic, assign) CGFloat value;
// slider值
@property (nonatomic, assign) CGFloat sliderValue;
// 处理中的图片（剪裁模式下为滤镜后的剪裁图片）
@property (nonatomic, strong) UIImage *processingImage;
// 原图的剪裁图片（仅剪裁模式下使用）
@property (nonatomic, strong) UIImage *origCuttedImg;
// 是否滑动了slider
@property (nonatomic, assign) BOOL processed;

@property (nonatomic, strong) IFImagePropertyModel *tempModel;

@end

@implementation IFEditImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.processed = NO;
    [self.view addSubview:self.editImageView];
    [self.view addSubview:self.editView];
    [self configProperties];
    if (self.editType == IFEditTypeCutting) {
        self.editView.slider.hidden = YES;
        [IFFilterUtils processImage:self.image withProperty:self.model completion:^(UIImage *image) {
            self.processedImage = image;
            [self.editImageView.imageView addSubview:self.clipperView];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self setStatusBarHidden:YES];
}

//- (void)setStatusBarHidden:(BOOL)hidden {
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    [statusBar setHidden:hidden];
//}

- (void)configProperties {
    if (_editType == IFEditTypeCutting) {
        self.titleLabel.text = @"剪裁";
    } else if (_editType == IFEditTypeBrightness) {
        self.titleLabel.text = @"亮度";
        [self.editView.slider setValue:self.model.brightnessSliderValue];
    } else if (_editType == IFEditTypeContrast) {
        self.titleLabel.text = @"对比度";
        [self.editView.slider setValue:self.model.contrastSliderValue];
    } else if (_editType == IFEditTypeColorTemperature) {
        self.titleLabel.text = @"色温";
        [self.editView.slider setValue:self.model.colorTemperatureSliderValue];
    } else if (_editType == IFEditTypeSaturation) {
        self.titleLabel.text = @"饱和度";
        [self.editView.slider setValue:self.model.saturationSliderValue];
    }
}

#pragma mark - setter

- (void)setImage:(UIImage *)image {
    if (!self.processedImage) {
        self.processedImage = image;
    }
    _image = image;
    self.editImageView.imageView.image = image;
}

- (void)setProcessedImage:(UIImage *)processedImage {
    if (_editType == IFEditTypeCutting) {
        _processedImage = processedImage;
    } else {
//        // 处理图片是 原图+剪裁+列表滤镜，没有单个滤镜
//        [IFFilterUtils filterImage:processedImage withFilter:[[IFFilterUtils filterArray] objectAtIndex:self.model.selectedFilterIndex] completion:^(UIImage *image) {
//            _processedImage = image;
//        }];
        _processedImage = processedImage;
    }
}

- (void)setModel:(IFImagePropertyModel *)model {
    _model = model;
    self.tempModel = [model copy];
}

#pragma mark - editView delegate

// “取消”“确定”点击回调
- (void)editView:(IFEditView *)editView didClickedButton:(UIButton *)button {
    if (button.tag == 1) {// 取消
        // 直接返回
    } else if (button.tag == 2) {// 确定
        if (self.processed==NO && self.editType!=IFEditTypeCutting) {
            [self dismissViewControllerAnimated:NO completion:nil];
            return;
        }
        self.processed = NO;
        // 防止滑动过快图片处理速度跟不上
        if (self.processingImage == nil) {
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(editImageController:didProcessedImage:property:originalCuttedImage:)]) {
            
            if (self.editType == IFEditTypeBrightness) {
                _model.brightnessValue = _tempModel.brightnessValue;
                _model.brightnessSliderValue = _tempModel.brightnessSliderValue;
            } else if (self.editType == IFEditTypeContrast) {
                _model.contrastValue = _tempModel.contrastValue;
                _model.contrastSliderValue = _tempModel.contrastSliderValue;
            } else if (self.editType == IFEditTypeColorTemperature) {
                _model.colorTemperatureValue = _tempModel.colorTemperatureValue;
                _model.colorTemperatureSliderValue = _tempModel.colorTemperatureSliderValue;
            } else if (self.editType == IFEditTypeSaturation) {
                _model.saturationValue = _tempModel.saturationValue;
                _model.saturationSliderValue = _tempModel.saturationSliderValue;
            }
            [self.delegate editImageController:self didProcessedImage:self.processingImage property:self.model originalCuttedImage:self.origCuttedImg];
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

// slider滑动回调
- (void)editView:(IFEditView *)editView sliderValueDidChanged:(CGFloat)value {
    if (!self.processedImage) { return; }
    self.processed = YES;
    self.sliderValue = value;
    // set方法里边修改图片
    self.value = value;
}

//亮度 -1.0到1.0
//变化从-0.5到0.5，确保不会过暗或过亮，默认(sender.value=0.5时)为0
//value = sender.value - 0.5;
//对比度 0.0到4.0
//变化从0.5到2，默认1
//value = sender.value * 2 < 0.5 ? 0.5 : sender.value * 2;
//锐化 -4.0到4.0
//变化从-2.0到2.0，默认0
//value = (sender.value - 0.5) * 4;
//饱和度 0到2.0
//变化从0到2.0，默认1
//value = sender.value * 2;
//褪色（实际是饱和度0.5到1）
//变化从0.5到1.0，默认1
//value = sender.value * 0.5 + 0.5;
//色温 temperature：1000到10000，默认5000

- (void)setValue:(CGFloat)value {
    CGFloat temp = 0;
    
    switch (self.editType) {
        case IFEditTypeBrightness: { // 亮度
            temp = (value - 0.5) / 2;
            if (fabs(_value - temp) < minSpacing/2) {
                return;
            }
            _value = temp;
            self.tempModel.brightnessValue = _value;
            self.tempModel.brightnessSliderValue = value;
        }
            break;
        case IFEditTypeContrast: {   // 对比度
            temp = value * 2 < 0.5 ? 0.5 : value * 2;
            if (fabs(_value - temp) < minSpacing) {
                return;
            }
            _value = temp;
            self.tempModel.contrastValue = _value;
            self.tempModel.contrastSliderValue = value;
        }
            break;
        case IFEditTypeColorTemperature: {// 色温
            temp = value;
            if (fabs(_value - temp) < minSpacing) {
                return;
            }
            if (value <= 0.5) {
                _value = 1000 + value * 8000;
            } else {
                _value = 5000 + (value - 0.5) * 10000;
            }
            /*
             // CoreImage的算法
             if (value >= 0.5) {
             _v41 = 6500;
             _v42 = 6500 - 9000 * (value - 0.5);
             } else {
             _v41 = 2000 + 9000 * value;
             _v42 = 6500;
             }*/
            self.tempModel.colorTemperatureValue = _value;
            self.tempModel.colorTemperatureSliderValue = value;
        }
            break;
        case IFEditTypeSaturation: { // 饱和度
            temp = value * 2;
            if (fabs(_value - temp) < minSpacing) {
                return;
            }
            _value = temp;
            self.tempModel.saturationValue = _value;
            self.tempModel.saturationSliderValue = value;
        }
            break;
        default:
            break;
    }
    [IFFilterUtils processImage:self.processedImage withProperty:self.tempModel completion:^(UIImage *image) {
        self.editImageView.imageView.image = image;
        self.processingImage = image;
    }];
}

#pragma mark - clipperView dataSource & delegate

- (UIImage *)imageForimageClipperView:(IFImageClipperView *)toolView {
    // 数据源传入的是原图
    return self.processedImage;
}

// 剪切回调
- (void)imageClipperView:(IFImageClipperView *)clipperView didClippedImage:(UIImage *)image withFrame:(CGRect)frame {
    // 返回的是带滤镜的剪裁图
    self.processingImage = image;
    // 原图的剪裁图
    self.origCuttedImg = [IFImageUtils cutImage:self.image withRect:frame];
}

#pragma mark - actions

- (IBAction)navgationBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.navBtnClick) {
            self.navBtnClick(sender.tag);
        }
    }];
}

#pragma mark - getter

- (IFEditImageView *)editImageView {
    if (!_editImageView) {
        _editImageView = [IFEditImageView createView];
    }
    return _editImageView;
}

- (IFEditView *)editView {
    if (!_editView) {
        _editView = [IFEditView createView];
        _editView.delegate = self;
    }
    return _editView;
}

- (IFImageClipperView *)clipperView {
    if (!_clipperView) {
        _clipperView = [[IFImageClipperView alloc] init];
        _clipperView.frame = self.editImageView.imageView.bounds;
        _clipperView.delegate = self;
        _clipperView.dataSource = self;
        _clipperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _clipperView;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
