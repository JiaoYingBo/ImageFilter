//
//  IFTextViewController.h
//  CasualShop
//
//  Created by 焦英博 on 2017/6/4.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFBaseViewController.h"

@interface IFTextViewController : IFBaseViewController

@property (nonatomic, copy) void(^text)(NSString *string);

@end
