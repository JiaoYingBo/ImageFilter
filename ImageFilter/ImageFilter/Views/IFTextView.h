//
//  IFTextView.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/4.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFTextView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, copy) void(^setText)(IFTextView *textView);

- (void)setBorderHidden:(BOOL)hidden;

@end
