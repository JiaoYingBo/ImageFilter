//
//  AlbumListCell.h
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/29.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@end
