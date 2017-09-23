//
//  IFImageClipperView.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/3.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFImageClipperView;
@protocol IFImageClipperViewDatasource <NSObject>

@required
- (UIImage *)imageForimageClipperView:(IFImageClipperView *)toolView;

@end

@protocol IFImageClipperViewDelegate <NSObject>

@optional
- (void)imageClipperView:(IFImageClipperView *)clipperView didClippedImage:(UIImage *)image withFrame:(CGRect)frame;

@end

@interface IFImageClipperView : UIView

@property (nonatomic, weak) id<IFImageClipperViewDatasource> dataSource;
@property (nonatomic, weak) id<IFImageClipperViewDelegate> delegate;

- (void)dismiss;

@end
