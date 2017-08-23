//
//  AlbumController.m
//  PhotosDemo
//
//  Created by 焦英博 on 2017/5/29.
//  Copyright © 2017年 焦英博. All rights reserved.
//

#import "AlbumController.h"
#import "PhotoController.h"
#import <Photos/Photos.h>
#import "AlbumListCell.h"
#import "AssetSelectionUtil.h"

@interface AlbumController ()<PHPhotoLibraryChangeObserver, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PHFetchResult<PHAsset *> *allPhotos;
@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *smartAlbums;
@property (nonatomic, strong) PHFetchResult<PHCollection *> *userCollections;

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, assign) CGSize thumbnailSize;

@end

@implementation AlbumController

- (instancetype)init {
    if (self = [super init]) {
        // 不要在viewDidLoad里修改
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
    }
    return self;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    self.thumbnailSize = CGSizeMake(60*scale, 60*scale); // cell上的图片大小是60
    
    [self fetchPhotosCompletion:^{
        [self.tableView reloadData];
    }];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[AssetSelectionUtil sharedUtil] clear];
}

- (void)fetchPhotosCompletion:(void(^)(void))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        self.allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
        self.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        self.userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        
        self.imageManager = [[PHCachingImageManager alloc] init];
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }
    });
}

#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AlbumListCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark - tableview datasource & delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
        {
            cell.titleLabel.text = @"所有照片";
            PHAsset *asset = self.allPhotos[0];
            cell.representedAssetIdentifier = asset.localIdentifier;
            [self.imageManager requestImageForAsset:asset targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                    cell.thumbImage.image = result;
                }
            }];
        }
            break;
        case 1:
        {
            PHAssetCollection *collection = self.smartAlbums[indexPath.row];
            cell.titleLabel.text = collection.localizedTitle;
            PHAsset *asset;
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            if (result.count != 0) {
                asset = result[0];
                cell.representedAssetIdentifier = asset.localIdentifier;
                [self.imageManager requestImageForAsset:asset targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                        cell.thumbImage.image = result;
                    }
                }];
            }
        }
            break;
        case 2:
        {
            PHCollection *collection = self.userCollections[indexPath.row];
            cell.titleLabel.text = collection.localizedTitle;
            PHAsset *asset;
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)collection options:nil];
            if (result.count != 0) {
                asset = result[0];
                cell.representedAssetIdentifier = asset.localIdentifier;
                [self.imageManager requestImageForAsset:asset targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                        cell.thumbImage.image = result;
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.allPhotos.count ? 1 : 0;
            break;
        case 1:
            return self.smartAlbums.count;
            break;
        case 2:
            return self.userCollections.count;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoController *photo = [[PhotoController alloc] init];
    
    AlbumListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    photo.navigationItem.title = cell.titleLabel.text;
    
    if (indexPath.section == 0) {
        photo.fetchResult = self.allPhotos;
    } else {
        PHCollection *collection;
        if (indexPath.section == 1) {
            collection = self.smartAlbums[indexPath.row];
        } else if (indexPath.section == 2) {
            collection = self.userCollections[indexPath.row];
        } else {
            return;
        }
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        photo.fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        photo.assetCollection = assetCollection;
    }
    
    [self.navigationController pushViewController:photo animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        PHFetchResultChangeDetails *changeDetails1 = [changeInstance changeDetailsForFetchResult:self.allPhotos];
//        if (changeDetails1) {
//            self.allPhotos = [changeDetails1 fetchResultAfterChanges];
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//        
//        PHFetchResultChangeDetails *changeDetails2 = [changeInstance changeDetailsForFetchResult:self.smartAlbums];
//        if (changeDetails2) {
//            self.smartAlbums = [changeDetails2 fetchResultAfterChanges];
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//        
//        PHFetchResultChangeDetails *changeDetails3 = [changeInstance changeDetailsForFetchResult:self.userCollections];
//        if (changeDetails3) {
//            self.userCollections = [changeDetails3 fetchResultAfterChanges];
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//    });
}

@end
