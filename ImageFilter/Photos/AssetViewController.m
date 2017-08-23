//
//  AssetViewController.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/31.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "AssetViewController.h"
#import "ImagePickerController.h"
#import "AssetCollectionCell.h"
#import "AssetTopView.h"
#import "AssetBottomView.h"
#import "AssetSelectionUtil.h"

@interface AssetViewController ()<PHPhotoLibraryChangeObserver, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AssetTopView *topToolView;
@property (nonatomic, strong) AssetBottomView *bottomToolView;

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, assign) CGRect previousPreheatRect;

@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation AssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    // 首次进入
//    if (!self.fetchResult && !self.assetCollection) {
//        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
//        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//        self.fetchResult = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
//        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
//    }
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    _currentIndex = 9999; // 解决选中0时不显示勾选的bug
    self.currentIndex = self.indexPath.item;
    
    self.collectionView.scrollsToTop = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [self.view addSubview:self.topToolView];
    [self.view addSubview:self.bottomToolView];
    [self updateSelectViews];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = self.view.bounds.size;
    self.thumbnailSize = CGSizeMake(cellSize.width*scale, cellSize.height*scale);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateCachedAssets];
}

#pragma mark - private method

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    if (!(self.isViewLoaded && self.view.window != nil)) {
        return;
    }
}

- (void)updateSelectViews {
    NSUInteger count = [AssetSelectionUtil sharedUtil].selectedPhotoIndexes.count;
    self.bottomToolView.count = count;
}

#pragma mark - collection datasource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.singleTapBlock = ^{
        [UIView animateWithDuration:0.05 animations:^{
            self.topToolView.hidden = !self.topToolView.hidden;
            self.bottomToolView.hidden = !self.bottomToolView.hidden;
        }];
    };
    
    
    PHAsset *asset = self.fetchResult[indexPath.item];
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = NO;
    [self.imageManager requestImageForAsset:asset targetSize:self.thumbnailSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
            if (result) {
                cell.image = result;
                if ([[AssetSelectionUtil sharedUtil].downloadingImages containsObject:asset.localIdentifier]) {
                    [[AssetSelectionUtil sharedUtil].downloadingImages removeObject:asset.localIdentifier];
                }
            } else {
                [[AssetSelectionUtil sharedUtil].downloadingImages addObject:asset.localIdentifier];
            }
        }
    }];
    
    return cell;
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat kWidth = [[UIScreen mainScreen] bounds].size.width + 10;
    NSInteger offsetX = (NSInteger)scrollView.contentOffset.x % (NSInteger)kWidth;
    NSInteger index = (NSInteger)scrollView.contentOffset.x / (NSInteger)kWidth;
    if (offsetX <= kWidth/2) {
        self.currentIndex = index;
    } else {
        self.currentIndex = index + 1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat kWidth = [[UIScreen mainScreen] bounds].size.width + 10;
    NSInteger index = (NSInteger)scrollView.contentOffset.x / (NSInteger)kWidth;
    self.currentIndex = index;
}

#pragma mark - setter

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    if (_currentIndex == currentIndex) { return; }
    
    _currentIndex = currentIndex;
    if ([[AssetSelectionUtil sharedUtil].selectedPhotoIndexes containsObject:@(currentIndex)]) {
        [self.topToolView setSelectButtonSelected:YES];
    } else {
        [self.topToolView setSelectButtonSelected:NO];
    }
    
    PHAsset *asset = self.fetchResult[currentIndex];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        self.topToolView.selectBtn.hidden = YES;
    } else {
        self.topToolView.selectBtn.hidden = NO;
    }
}

#pragma mark - lazy load

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.bounds.size.width+10, self.view.bounds.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width+10, self.view.bounds.size.height) collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AssetCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (AssetTopView *)topToolView {
    if (!_topToolView) {
        _topToolView = [AssetTopView createView];
        _topToolView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        __weak typeof(self)weakSelf = self;
        _topToolView.backBtnClick = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _topToolView.selectBtnClick = ^(BOOL isSelected) {
            if (isSelected) {
                if ([AssetSelectionUtil sharedUtil].selectedPhotoIndexes.count == [AssetSelectionUtil sharedUtil].maxImagesCount) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"最多只能选择5张照片" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action1];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                    return NO;
                }
                [[AssetSelectionUtil sharedUtil].selectedPhotoIndexes addObject:@(weakSelf.currentIndex)];
            } else {
                [[AssetSelectionUtil sharedUtil].selectedPhotoIndexes removeObject:@(weakSelf.currentIndex)];
            }
            [weakSelf updateSelectViews];
            return YES;
        };
    }
    return _topToolView;
}

- (AssetBottomView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [AssetBottomView createView];
        _bottomToolView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44);
        
        [AssetSelectionUtil sharedUtil].fetchResult = self.fetchResult;
        __weak typeof(self) weakSelf = self;
        _bottomToolView.completionBtnClick = ^BOOL{
            PHAsset *asset = weakSelf.fetchResult[weakSelf.currentIndex];
            if ([[AssetSelectionUtil sharedUtil].downloadingImages containsObject:asset.localIdentifier]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有图片正在从iCloud下载中" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            } else {
                ImagePickerController *picker = (ImagePickerController *)weakSelf.navigationController;
                [picker downloadImages];
                return YES;
            }
        };
    }
    return _bottomToolView;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
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

#pragma mark - actions

- (void)cancelButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - statusBar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
