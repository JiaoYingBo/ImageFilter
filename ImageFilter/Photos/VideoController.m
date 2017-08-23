//
//  VideoController.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/6/1.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "VideoController.h"
#import "ImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoBottomView.h"
#import "AssetSelectionUtil.h"

@interface VideoController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) VideoBottomView *bottomToolView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@property (nonatomic, assign) BOOL playEnded;
@property (nonatomic, assign) BOOL firstPlay;
@property (nonatomic, strong) UIImage *orginalImage;
@property (nonatomic, strong) UIImage *clearImage;

@end

@implementation VideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstPlay = YES;
    self.playEnded = NO;
    self.bottomToolView.completionBtnEnabled = [AssetSelectionUtil sharedUtil].mediaType != ASFetchMediaTypeImage;
    
    self.navigationItem.title = @"预览";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.bottomToolView];
    
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [self.playButton setBackgroundImage:result forState:UIControlStateNormal];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.orginalImage = self.playButton.currentBackgroundImage;
    self.clearImage = [self pv_imageWithColor:[UIColor clearColor] size:CGSizeMake(200, 200)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}

- (void)initPlayerCompletion:(void(^)(void))block {
    [self.view.layer addSublayer:self.playerLayer];
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:self.asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.player replaceCurrentItemWithPlayerItem:playerItem];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
            [self.player play];
            
            if (block) {
                block();
            }
        });
    }];
}

#pragma mark - actions

- (IBAction)PlayBtnClick:(UIButton *)sender {
    if (self.firstPlay) {
        [self initPlayerCompletion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                [self hideToolViews];
                [self.playButton setBackgroundImage:self.clearImage forState:UIControlStateNormal];
            });
            
        }];
        self.firstPlay = NO;
        return;
    }
    
    [self play];
    [self hideToolViews];
}

- (IBAction)pauseBtnClick:(UIButton *)sender {
    [self.player pause];
    [self showToolViews];
}

- (void)play {
    if (self.playEnded) {
        [self.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        self.playEnded = NO;
        [self.playButton setBackgroundImage:self.clearImage forState:UIControlStateNormal];
    }
    [self.player play];
}

- (void)hideToolViews {
    self.playButton.hidden = YES;
    self.bottomToolView.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)showToolViews {
    self.playButton.hidden = NO;
    self.bottomToolView.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.view bringSubviewToFront:self.playButton];
    [self.view bringSubviewToFront:self.bottomToolView];
}

#pragma mark - observer

- (void)playbackFinished:(NSNotification *)noti {
    self.playEnded = YES;
    [self showToolViews];
    [self.playButton setBackgroundImage:self.orginalImage forState:UIControlStateNormal];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"status"]) {
//        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
//        if (status == AVPlayerStatusReadyToPlay) {
//            [self hideToolViews];
//            [self.playButton setBackgroundImage:self.clearImage forState:UIControlStateNormal];
//        }
//    }
//}

#pragma mark - lazy load

- (VideoBottomView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [VideoBottomView createView];
        _bottomToolView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44);
        
        __weak typeof(self) weakSelf = self;
        _bottomToolView.completionBtnClick = ^{
            [AssetSelectionUtil sharedUtil].videoURL = [(AVURLAsset *)weakSelf.player.currentItem.asset URL];
            [AssetSelectionUtil sharedUtil].videoAsset = weakSelf.asset;
            ImagePickerController *picker = (ImagePickerController *)weakSelf.navigationController;
            [picker downloadVideo];
        };
    }
    return _bottomToolView;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.view.bounds;
    }
    return _playerLayer;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

#pragma mark - tools

- (UIImage *)pv_imageWithColor:(UIColor *)color size:(CGSize)size {
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillRect(ctx, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

@end
