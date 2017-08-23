//
//  CollectionViewCell.m
//  CollectionViewPhoto
//
//  Created by Mac on 16/4/19.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgView.clipsToBounds = YES;
    _selectBtn.selected = NO;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imgView.image = nil;
    self.selectBtn.selected = NO;
    self.select = NO;
    [self.selectBtn setImage:[UIImage imageNamed:@"as_photo_def"] forState:UIControlStateNormal];
}

#pragma mark - actions

- (IBAction)click:(UIButton *)sender {
    if (self.selectBtnClick) {
        if (!self.selectBtnClick(!sender.selected)) { return; }
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"as_photo_sel_small"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"as_photo_def"] forState:UIControlStateNormal];
    }
}

#pragma mark - setter

- (void)setSelect:(BOOL)select {
    _select = select;
    self.selectBtn.selected = select;
    
    if (select) {
        [self.selectBtn setImage:[UIImage imageNamed:@"as_photo_sel_small"] forState:UIControlStateNormal];
    } else {
        [self.selectBtn setImage:[UIImage imageNamed:@"as_photo_def"] forState:UIControlStateNormal];
    }
}

@end
