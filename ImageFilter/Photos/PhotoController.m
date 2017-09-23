//
//  PhotoController.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/29.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "PhotoController.h"
#import "AssetViewController.h"
#import "ImagePickerController.h"
#import "VideoController.h"
#import "CollectionViewCell.h"
#import "AssetBottomView.h"
#import "AssetSelectionUtil.h"
#import "ASTakePhotoCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface PhotoController ()<PHPhotoLibraryChangeObserver, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AssetBottomView *bottomToolView;

@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *smartAlbums;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, assign) CGRect previousPreheatRect;

@property (nonatomic, assign) BOOL showTakePhoto;// 是否显示拍照按钮

@property (assign,nonatomic) BOOL isVideo;// 1表示录制视频，0代表拍照
@property (strong,nonatomic) UIImagePickerController *imagePicker;

@end

@implementation PhotoController

#pragma mark

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    
    [self firstInConfig];
    if ([self.navigationItem.title isEqualToString:@"所有照片"]) {
        self.showTakePhoto = YES;
    } else {
        self.showTakePhoto = NO;
        if ([AssetSelectionUtil sharedUtil].mediaType == ASFetchMediaTypeVideo) {
            self.showTakePhoto = YES;
        }
    }
    
    self.collectionView.scrollsToTop = NO;
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomToolView];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = [[UICollectionViewFlowLayout alloc] init].itemSize;
    self.thumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateCachedAssets];
}

#pragma mark - private method

- (void)firstInConfig {
    // 首次进入
    if (!self.fetchResult && !self.assetCollection) {
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
            options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
        }
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        if ([AssetSelectionUtil sharedUtil].mediaType == ASFetchMediaTypeImage || [AssetSelectionUtil sharedUtil].mediaType == ASFetchMediaTypeDefault) {
            // 照片
            self.fetchResult = [PHAsset fetchAssetsWithOptions:options];
            
        } else if ([AssetSelectionUtil sharedUtil].mediaType == ASFetchMediaTypeVideo) {
            // 视频
            self.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            PHAssetCollection *assetCollection = nil;
            for (PHAssetCollection *collection in self.smartAlbums) {
                if ([collection.localizedTitle isEqualToString:@"Videos"] || [collection.localizedTitle isEqualToString:@"视频"]) {
                    assetCollection = collection;
                    break;
                }
            }
            
            self.fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            self.assetCollection = assetCollection;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
}

- (void)resetCachedAssets {
    if (![self authorizationVerification]) {
        return;
    }
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    if (!(self.isViewLoaded && self.view.window != nil)) {
        return;
    }
}

- (BOOL)authorizationVerification {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设置中打开相册权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    } else {
        if (status == PHAuthorizationStatusNotDetermined) {
            return NO;
        }
        return YES;
    }
}

- (void)updateSelectViews {
    NSUInteger count = [AssetSelectionUtil sharedUtil].selectedPhotoIndexes.count;
    self.bottomToolView.count = count;
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.showTakePhoto) {
        return self.fetchResult.count + 1;
    }
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = self.showTakePhoto ? indexPath.item - 1 : indexPath.item;
    
    if (self.showTakePhoto) {
        if (indexPath.item == 0) {
            ASTakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstCell" forIndexPath:indexPath];
            return cell;
        }
    }
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.selectBtnClick = ^(BOOL isSelected){
        if (isSelected) {
            if ([AssetSelectionUtil sharedUtil].selectedPhotoIndexes.count == [AssetSelectionUtil sharedUtil].maxImagesCount) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"最多只能选择%td张照片", [AssetSelectionUtil sharedUtil].maxImagesCount] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action1];
                [self presentViewController:alert animated:YES completion:nil];
                
                return NO;
            }
            [[AssetSelectionUtil sharedUtil].selectedPhotoIndexes addObject:@(index)];
        } else {
            [[AssetSelectionUtil sharedUtil].selectedPhotoIndexes removeObject:@(index)];
        }
        [self updateSelectViews];
        return YES;
    };
    
    if ([[AssetSelectionUtil sharedUtil].selectedPhotoIndexes containsObject:@(index)]) {
        cell.select = YES;
        [self updateSelectViews];
    }
    
    
    PHAsset *asset = self.fetchResult[index];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        cell.selectBtn.hidden = YES;
        cell.bottomView.hidden = NO;
        cell.timeLabel.text = [[AssetSelectionUtil sharedUtil] timeFormat:(NSUInteger)asset.duration];
    } else {
        cell.selectBtn.hidden = NO;
        cell.bottomView.hidden = YES;
    }
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    [self.imageManager requestImageForAsset:asset targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
            cell.imgView.image = result;
        }
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showTakePhoto) {
        if (indexPath.item == 0) {
            if ([AssetSelectionUtil sharedUtil].mediaType == ASFetchMediaTypeVideo) {
                self.isVideo = YES;
            } else {
                self.isVideo = NO;
            }
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            return;
        }
    }
    
    NSUInteger index = self.showTakePhoto ? indexPath.item - 1 : indexPath.item;
    /*
     typedef NS_ENUM(NSInteger, PHAssetMediaType) {
     PHAssetMediaTypeUnknown = 0,
     PHAssetMediaTypeImage   = 1,
     PHAssetMediaTypeVideo   = 2,
     PHAssetMediaTypeAudio   = 3,
     }
     */
    PHAsset *asset = self.fetchResult[index];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        VideoController *video = [[VideoController alloc] init];
        video.asset = asset;
        [self.navigationController pushViewController:video animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        return;
    }
    
    
    AssetViewController *ass = [[AssetViewController alloc] init];
    ass.indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    ass.fetchResult = self.fetchResult;
    ass.assetCollection = self.assetCollection;
    [self.navigationController pushViewController:ass animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - lazy load

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width  = self.view.bounds.size.width;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat size = (width-25)/4;
        layout.itemSize = CGSizeMake(size, size);
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"ASTakePhotoCell" bundle:nil] forCellWithReuseIdentifier:@"firstCell"];
    }
    return _collectionView;
}

- (AssetBottomView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [AssetBottomView createView];
        _bottomToolView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44);
        _bottomToolView.themeStyle = ASThemeStyleLight;
        
        __weak typeof(self) weakSelf = self;
        _bottomToolView.completionBtnClick = ^BOOL{
            [AssetSelectionUtil sharedUtil].fetchResult = weakSelf.fetchResult;
            ImagePickerController *picker = (ImagePickerController *)weakSelf.navigationController;
            [picker downloadImages];
            return YES;
        };
    }
    return _bottomToolView;
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        if (self.isVideo) {
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
            _imagePicker.videoMaximumDuration = 10.0;
            _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
        }else{
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        _imagePicker.allowsEditing = NO;//允许编辑
        _imagePicker.delegate = self;//设置代理，检测操作
    }
    return _imagePicker;
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
        UIImage *image;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.imagePicker.allowsEditing) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
//        [self.photo setImage:image];//显示照片
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *temp = [[AssetSelectionUtil sharedUtil].selectedPhotoIndexes copy];
    for (int i = 0; i < temp.count; i ++) {
        NSNumber *num = temp[i];
        NSUInteger index = [num integerValue];
        index ++;
        [[AssetSelectionUtil sharedUtil].selectedPhotoIndexes replaceObjectAtIndex:i withObject:@(index)];
    }
    [self.collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:^{
//        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
//        NSURL *url=[NSURL fileURLWithPath:videoPath];
//        _player=[AVPlayer playerWithURL:url];
//        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
//        playerLayer.frame=self.photo.frame;
//        [self.photo.layer addSublayer:playerLayer];
//        [_player play];
    }
}

#pragma mark - PHPhotoLibraryChangeObserver

/* 有空再写动态更新 */
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    PHFetchResultChangeDetails *changes = [changeInstance changeDetailsForFetchResult:self.fetchResult];
    if (!changes) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        if ([AssetSelectionUtil sharedUtil].mediaType == ASFetchMediaTypeVideo) {
            
            self.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            PHAssetCollection *assetCollection = nil;
            for (PHAssetCollection *collection in self.smartAlbums) {
                if ([collection.localizedTitle isEqualToString:@"Videos"] || [collection.localizedTitle isEqualToString:@"视频"]) {
                    assetCollection = collection;
                    break;
                }
            }
            self.fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            self.assetCollection = assetCollection;
            
        } else {
            self.fetchResult = [PHAsset fetchAssetsWithOptions:options];
        }
        
        self.imageManager = [[PHCachingImageManager alloc] init];
        [self resetCachedAssets];
        [self.collectionView reloadData];
    });
    
    
//    PHFetchResultChangeDetails *changes = [changeInstance changeDetailsForFetchResult:self.fetchResult];
//    if (!changes) {
//        return;
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.fetchResult = changes.fetchResultAfterChanges;
//        if (changes.hasIncrementalChanges) {
//            NSLog(@"111");
//            [self.collectionView performBatchUpdates:^{
//                NSLog(@"222");
//                if ([changes removedIndexes].count > 0) {
//                    NSLog(@"333");
//                    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[changes removedIndexes].firstIndex inSection:0]]];
//                }
//                if ([changes insertedIndexes].count > 0) {
//                    NSLog(@"444");
//                    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[changes insertedIndexes].firstIndex inSection:0]]];
//                }
//                if ([changes changedIndexes].count > 0) {
//                    NSLog(@"555");
//                    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[changes changedIndexes].firstIndex inSection:0]]];
//                }
//                NSLog(@"666");
//                [changes enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
//                    [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:0] toIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]];
//                }];
//            } completion:nil];
//        } else {
//            [self.collectionView reloadData];
//        }
//        [self resetCachedAssets];
//    });
}

#pragma mark - statusBar

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
