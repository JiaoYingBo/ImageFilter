//
//  IFImageEditor.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/15.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#ifndef IFImageEditor_h
#define IFImageEditor_h

// 编辑类型，都不需要时传-1
typedef NS_ENUM(NSUInteger, IFEditType) {
    IFEditTypeCutting = 0,      // 剪裁
    IFEditTypeBrightness,       // 亮度
    IFEditTypeContrast,         // 对比度
    IFEditTypeColorTemperature, // 色温
    IFEditTypeSaturation        // 饱和度
};


#endif /* IFImageEditor_h */
