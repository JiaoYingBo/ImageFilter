//
//  ImagePickerController.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/29.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "ImagePickerController.h"
#import "AlbumController.h"
#import "PhotoController.h"
#import "AssetSelectionUtil.h"
#import "FileUtility.h"

@interface ImagePickerController ()

@property (nonatomic, strong) NSMutableArray *thumbImages;
@property (nonatomic, strong) NSMutableArray<UIImage *> *originalImages;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *infos;

@property (nonatomic, strong) NSTimer *timer;

// YES：由于iCloud下载问题已经弹过alert NO：没有弹过
@property (nonatomic, assign) BOOL iCloudFlag;

@end

@implementation ImagePickerController

- (instancetype)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        _iCloudFlag = NO;
        [self defaultConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (status == PHAuthorizationStatusAuthorized) {
                [self setupControllers];
            } else if (status == PHAuthorizationStatusNotDetermined) {
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"发布笔记需要照片权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:cancelAction];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        });
    }];
}

- (void)dealloc {
    NSLog(@"ImagePicker dealloc");
}

- (void)setupControllers {
    if (self.mediaType == ASFetchMediaTypeImage) {
        AlbumController *album = [[AlbumController alloc] init];
        album.navigationItem.title = @"相册";
        PhotoController *photo = [[PhotoController alloc] init];
        photo.navigationItem.title = @"所有照片";
        [self setViewControllers:@[album, photo] animated:NO];
    } else if (self.mediaType == ASFetchMediaTypeDefault) {
        AlbumController *album = [[AlbumController alloc] init];
        album.navigationItem.title = @"相册";
        PhotoController *photo = [[PhotoController alloc] init];
        photo.navigationItem.title = @"所有照片";
        [self setViewControllers:@[album, photo] animated:NO];
    } else {
        PhotoController *photo = [[PhotoController alloc] init];
        photo.navigationItem.title = @"视频";
        [self setViewControllers:@[photo] animated:NO];
    }
}

#pragma mark - setter

- (void)setMaxImagesCount:(NSUInteger)maxImagesCount {
    _maxImagesCount = maxImagesCount;
    [AssetSelectionUtil sharedUtil].maxImagesCount = _maxImagesCount;
}

- (void)setMediaType:(ASFetchMediaType)mediaType {
    _mediaType = mediaType;
    [AssetSelectionUtil sharedUtil].mediaType = _mediaType;
}

#pragma mark - private method

- (void)defaultConfig {
    _mediaType = ASFetchMediaTypeDefault;
    [AssetSelectionUtil sharedUtil].mediaType = _mediaType;
    _maxImagesCount = 9;
    [AssetSelectionUtil sharedUtil].maxImagesCount = _maxImagesCount;
}

#pragma mark - public method

- (void)downloadImages {
    _iCloudFlag = NO;
    for (NSUInteger i = 0; i < [AssetSelectionUtil sharedUtil].selectedPhotoIndexes.count; i ++) {
        // 加入@1以判断多个分线程是否都已回调完毕
        [self.thumbImages addObject:@1];
        NSNumber *number = [AssetSelectionUtil sharedUtil].selectedPhotoIndexes[i];
        PHAsset *asset = [AssetSelectionUtil sharedUtil].fetchResult[[number integerValue]];
        [self getImagesWithAsset:asset index:i];
    }
}

#pragma mark - 代理回调

- (void)getImagesWithAsset:(PHAsset *)asset index:(NSUInteger)index {
    [self getOriginalPhotosAndInfosWithAsset:asset completion:^(BOOL cancel) {
        if (cancel) {
            _iCloudFlag = YES;
            return;
        }
        [self getThumbPhotosWithAsset:asset completion:^(UIImage *image, BOOL cancel) {
            if (cancel) {
                _iCloudFlag = YES;
                return;
            }
            
            [self.thumbImages replaceObjectAtIndex:index withObject:image];
            
            if ([self.thumbImages containsObject:@1]) { return; }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self.pickerDelegate respondsToSelector:@selector(imagePickerController:disFinishPickingThumbImages:originalImages:infos:)]) {
                        [self.pickerDelegate imagePickerController:self disFinishPickingThumbImages:self.thumbImages originalImages:self.originalImages infos:self.infos];
                    }
                }];
            });
        }];
    }];
}

- (void)downloadVideo {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text = @"正在压缩视频...";
//    
//    [self compressAndCacheVideoWithAsset:[AssetSelectionUtil sharedUtil].videoAsset completion:^(NSString *path) {
//        [[PHImageManager defaultManager] requestImageDataForAsset:[AssetSelectionUtil sharedUtil].videoAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//            
//            [hud hideAnimated:YES];
//            
//            [self dismissViewControllerAnimated:YES completion:^{
//                if ([self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideoPath:coverImage:)]) {
//                    [self.pickerDelegate imagePickerController:self didFinishPickingVideoPath:path coverImage:[UIImage imageWithData:imageData]];
//                    [[AssetSelectionUtil sharedUtil] clear];
//                }
//            }];
//        }];
//    }];
}

#pragma mark - 获取图片

- (void)getOriginalPhotosAndInfosWithAsset:(PHAsset *)asset completion:(void(^)(BOOL cancel))block {
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (!imageData) {
            if (!_iCloudFlag) {
                // 如果没有显示过alert就弹出alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有图片正在从iCloud下载中" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            if (block) {
                block(YES);
            }
        } else {
            [self.originalImages addObject:[UIImage imageWithData:imageData]];
            [self.infos addObject:info];
            if (block) {
                block(NO);
            }
        }
    }];
}

- (void)getThumbPhotosWithAsset:(PHAsset *)asset completion:(void(^)(UIImage * ,BOOL cancel))block {
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (!result) {
            if (!_iCloudFlag) {
                // 如果没有显示过alert就弹出alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有图片正在从iCloud下载中" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            if (block) {
                block(nil, YES);
            }
        } else {
            if (block) {
                block(result, NO);
            }
        }
    }];
}

#pragma mark - 视频压缩
/**
 *  @author lincf, 16-06-15 13:06:26
 *
 *  视频压缩并缓存压缩后视频 (将视频格式变为mp4)
 *
 *  @param asset      PHAsset／ALAsset
 *  @param completion 回调压缩后视频路径，可以复制或剪切
 */
- (void)compressAndCacheVideoWithAsset:(id)asset completion:(void (^)(NSString *path))completion
{
    if (completion == nil) return;
    NSString *cache = [self CacheVideoPath];
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        if ([asset isKindOfClass:[AVURLAsset class]]) {
            NSURL *url = ((AVURLAsset *)asset).URL;
            if (url) {
                NSString *videoName = [[url.lastPathComponent stringByDeletingPathExtension] stringByAppendingString:@".mp4"];
                NSString *path = [cache stringByAppendingPathComponent:videoName];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                }
                
                [self encodeVideoWithAsset:asset outPath:path complete:^(BOOL isSuccess, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            completion(nil);
                        }else{
                            completion(path);
                        }
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
        }
    }];
}

- (NSString *)CacheVideoPath
{
    NSString *bundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:(id)kCFBundleIdentifierKey];
    NSString *fullNamespace = [bundleId stringByAppendingPathComponent:@"videoCache"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths.firstObject stringByAppendingPathComponent:fullNamespace];
    
    [FileUtility createFolder:cachePath errStr:nil];
    
    return cachePath;
}

/** 视频压缩 */
- (void)encodeVideoWithURL:(NSURL *)videoURL outPath:(NSString *)outPath complete:(void (^)(BOOL isSuccess, NSError *error))complete
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    [self encodeVideoWithAsset:asset outPath:outPath complete:complete];
}
- (void)encodeVideoWithAsset:(AVAsset *)asset outPath:(NSString *)outPath complete:(void (^)(BOOL isSuccess, NSError *error))complete
{
    if (complete == nil) return;
    if (asset == nil || outPath.length == 0) {
        complete(NO, nil);
    }
    
    if ([asset isKindOfClass:[AVURLAsset class]]) {
        NSLog(@"压缩前：%@",[FileUtility getFileSizeString:[FileUtility fileSizeForPath:[((AVURLAsset *)asset).URL path]]]);
    }
    CFTimeInterval time = CACurrentMediaTime();
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
    
    AVMutableVideoComposition *waterMarkVideoComposition;
    
    UIImageOrientation orientation = [self orientationFromAVAssetTrack:videoTrack];
    
    if (orientation != UIImageOrientationUp) {
        waterMarkVideoComposition = [AVMutableVideoComposition videoComposition];
        waterMarkVideoComposition.frameDuration = CMTimeMake(1, 30);
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            //顺时针旋转270°
            //            NSLog(@"视频旋转270度，home按键在右");
            transform = CGAffineTransformTranslate(transform, 0.0, videoTrack.naturalSize.width);
            transform = CGAffineTransformRotate(transform,M_PI_2*3.0);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            break;
        case UIImageOrientationRight:
            //顺时针旋转90°
            //            NSLog(@"视频旋转90度,home按键在左");
            transform = CGAffineTransformTranslate(transform, videoTrack.naturalSize.height, 0.0);
            transform = CGAffineTransformRotate(transform,M_PI_2);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            break;
        case UIImageOrientationDown:
            //顺时针旋转180°
            //            NSLog(@"视频旋转180度，home按键在上");
            transform = CGAffineTransformTranslate(transform, videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            transform = CGAffineTransformRotate(transform,M_PI);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            break;
        default:
            break;
    }
    
    if (waterMarkVideoComposition) {
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        [roateLayerInstruction setTransform:transform atTime:kCMTimeZero];
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        //将视频方向旋转加入到视频处理中
        waterMarkVideoComposition.instructions = @[roateInstruction];
    }
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = [NSURL fileURLWithPath:outPath];
    exportSession.videoComposition = waterMarkVideoComposition;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch ([exportSession status])
         {
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"MP4 Successful!");
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                 break;
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"Export canceled");
                 break;
             default:
                 break;
         }
         NSLog(@"Completed compression in %f s",CACurrentMediaTime() - time);
         NSString *fileSizeStr = [FileUtility getFileSizeString:[FileUtility fileSizeForPath:outPath]];
         NSLog(@"压缩后：%@",fileSizeStr);
         complete([exportSession status] == AVAssetExportSessionStatusCompleted, exportSession.error);
     }];
}

- (UIImageOrientation)orientationFromAVAssetTrack:(AVAssetTrack *)videoTrack
{
    UIImageOrientation orientation = UIImageOrientationUp;
    
    CGAffineTransform t = videoTrack.preferredTransform;
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
        // Portrait
        //        degress = 90;
        orientation = UIImageOrientationRight;
    }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
        // PortraitUpsideDown
        //        degress = 270;
        orientation = UIImageOrientationLeft;
    }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
        // LandscapeRight
        //        degress = 0;
        orientation = UIImageOrientationUp;
    }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        // LandscapeLeft
        //        degress = 180;
        orientation = UIImageOrientationDown;
    }
    
    return orientation;
}

#pragma mark - lazy load

- (NSMutableArray *)thumbImages {
    if (!_thumbImages) {
        _thumbImages = [NSMutableArray arrayWithCapacity:9];
    }
    return _thumbImages;
}

- (NSMutableArray<UIImage *> *)originalImages {
    if (!_originalImages) {
        _originalImages = [NSMutableArray arrayWithCapacity:9];
    }
    return _originalImages;
}

- (NSMutableArray<NSDictionary *> *)infos {
    if (!_infos) {
        _infos = [NSMutableArray arrayWithCapacity:9];
    }
    return _infos;
}

@end
