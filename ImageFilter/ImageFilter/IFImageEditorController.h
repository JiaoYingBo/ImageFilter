//
//  IFImageEditorController.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/2.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFImageEditorController;
@protocol IFImageEditorControllerDelegate <NSObject>

@optional
- (void)imageEditorController:(IFImageEditorController *)editorController processedImages:(NSArray<UIImage *> *)images;

@end

@interface IFImageEditorController : UINavigationController

@property (nonatomic, weak) id<IFImageEditorControllerDelegate> editorDelegate;
@property (nonatomic, strong) NSArray *originalImagesArray;
@property (nonatomic, assign) NSUInteger selectIndex;

@end
