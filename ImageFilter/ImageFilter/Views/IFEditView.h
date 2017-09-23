//
//  IFEditView.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/14.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFEditView;
@protocol IFEditViewDelegate <NSObject>

@optional
- (void)editView:(IFEditView *)editView didClickedButton:(UIButton *)button;
- (void)editView:(IFEditView *)editView sliderValueDidChanged:(CGFloat)value;

@end

@interface IFEditView : UIView

@property (nonatomic, weak) id<IFEditViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISlider *slider;

//@property (nonatomic, assign) CGFloat sliderValue;

+ (instancetype)createView;

@end
