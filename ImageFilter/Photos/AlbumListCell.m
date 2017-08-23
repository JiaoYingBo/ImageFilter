//
//  AlbumListCell.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/29.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "AlbumListCell.h"

@implementation AlbumListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.thumbImage.image = [UIImage imageNamed:@"as_placeholder"];
    self.titleLabel.text = @"";
}

@end
