//
//  IFFilterToolCell.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/3.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFFilterToolCell.h"

@implementation IFFilterToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedView.layer.borderColor = [UIColor redColor].CGColor;
    self.selectedView.layer.borderWidth = 3;
}

- (void)setSelect:(BOOL)select {
    _select = select;
    if (select) {
        self.selectedView.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        self.selectedView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
