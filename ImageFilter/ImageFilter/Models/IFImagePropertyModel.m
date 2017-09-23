//
//  IFImagePropertyModel.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/14.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFImagePropertyModel.h"

@implementation IFImagePropertyModel

- (instancetype)init {
    if (self = [super init]) {
        _selectedFilterIndex = 0;
        _selectedMyStickerIndex = 0;
        _selectedActivityStickerIndex = 0;
        _brightnessValue = 0;
        _brightnessSliderValue = 0.5;
        _contrastValue = 1;
        _contrastSliderValue = 0.5;
        _colorTemperatureValue = 5000;
        _colorTemperatureSliderValue = 0.5;
        _saturationValue = 1;
        _saturationSliderValue = 0.5;
        _borderHidden = YES;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    IFImagePropertyModel *model = [[IFImagePropertyModel alloc] init];
    model.selectedFilterIndex = self.selectedFilterIndex;
    model.selectedMyStickerIndex = self.selectedMyStickerIndex;
    model.selectedActivityStickerIndex = self.selectedActivityStickerIndex;
    model.brightnessValue = self.brightnessValue;
    model.brightnessSliderValue = self.brightnessSliderValue;
    model.contrastValue = self.contrastValue;
    model.contrastSliderValue = self.contrastSliderValue;
    model.colorTemperatureValue = self.colorTemperatureValue;
    model.colorTemperatureSliderValue = self.colorTemperatureSliderValue;
    model.saturationValue = self.saturationValue;
    model.saturationSliderValue = self.saturationSliderValue;
    model.originalImage = self.originalImage;
    model.cuttedOriginalImage = self.cuttedOriginalImage;
    model.processedImage = self.processedImage;
    model.scale = self.scale;
    model.text = self.text;
    model.textFrame = self.textFrame;
    model.borderHidden = self.borderHidden;
    return model;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n滤镜：%td 亮度：%.2f 亮度杆：%.2f 对比度：%.2f 对比度杆：%.2f 色温：%.2f 色温杆：%.2f 饱和度：%.2f 饱和度杆：%.2f 比例：%.2f 文字：%@ 文字坐标：%@ 隐藏：%d", _selectedFilterIndex, _brightnessValue, _brightnessSliderValue, _contrastValue, _contrastSliderValue, _colorTemperatureValue, _colorTemperatureSliderValue, _saturationValue, _saturationSliderValue, _scale, _text, NSStringFromCGRect(_textFrame), _borderHidden];
}

@end
