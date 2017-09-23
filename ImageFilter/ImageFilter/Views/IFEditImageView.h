//
//  IFEditImageView.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/14.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFEditImageView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+ (instancetype)createView;

@end
