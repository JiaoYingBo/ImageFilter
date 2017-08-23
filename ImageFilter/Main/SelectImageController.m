//
//  SelectImageController.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/8/23.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "SelectImageController.h"
#import "ImagePickerController.h"
#import "RootTabBarController.h"

@interface SelectImageController () <ImagePickerControllerDelegate>

@end

@implementation SelectImageController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)selectBtnClick:(id)sender {
    ImagePickerController *picker = [[ImagePickerController alloc] init];
    picker.pickerDelegate = self;
    picker.maxImagesCount = 1;
    picker.mediaType = ASFetchMediaTypeDefault;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ImagePickerControllerDelegate

- (void)imagePickerController:(ImagePickerController *)controller disFinishPickingThumbImages:(NSArray<UIImage *> *)thumbImages originalImages:(NSArray<UIImage *> *)originalImages infos:(NSArray<NSDictionary *> *)infos {
    [CommonTools shared].image = originalImages[0];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    RootTabBarController *tabbar = [[RootTabBarController alloc] init];
    window.rootViewController = tabbar;
    [UIView animateWithDuration:1 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
    }];
}

@end
