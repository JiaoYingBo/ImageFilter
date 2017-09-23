//
//  IFEditorViewController.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/2.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFBaseViewController.h"

@class IFEditorViewController;
@protocol IFEditorViewControllerDelegate <NSObject>

@optional
// 处理后的图片
- (void)editorViewController:(IFEditorViewController *)editorController processedImages:(NSArray<UIImage *> *)images;

@end

@interface IFEditorViewController : IFBaseViewController

@property (nonatomic, weak) id<IFEditorViewControllerDelegate> delegate;
// 原始图片
@property (nonatomic, strong) NSArray *originalImagesArray;

@property (nonatomic, assign) NSUInteger selectIndex;

@end
