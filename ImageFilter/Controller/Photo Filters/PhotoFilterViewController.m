//
//  PhotoFilterViewController.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "PhotoFilterViewController.h"
#import "PhotoFilterCollectionViewCell.h"
#import "FilteredImageView.h"

@interface PhotoFilterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FilteredImageView *filteredImageView;
@property (nonatomic, strong) NSMutableArray *filters;
@property (nonatomic, strong) NSArray *filterDescriptors;

@end

@implementation PhotoFilterViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
}

#pragma mark - collection delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.filteredImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.filteredImageView.inputImage = self.filteredImageView.inputImage;
    cell.filteredImageView.filter = self.filters[indexPath.item];
    cell.filterNameLabel.text = self.filterDescriptors[indexPath.item][1];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterDescriptors.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.filteredImageView.filter = self.filters[indexPath.item];
}

#pragma mark - UI

- (void)setupUI {
    self.navigationItem.title = @"Photo Filters";
    self.view.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.filteredImageView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:100]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-49]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:64]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(66, 86);
        layout.minimumLineSpacing = 3;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView registerClass:[PhotoFilterCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (FilteredImageView *)filteredImageView {
    if (!_filteredImageView) {
        _filteredImageView = [[FilteredImageView alloc] init];
        _filteredImageView.inputImage = [UIImage imageNamed:@"666.jpg"];
        _filteredImageView.filter = self.filters[0];
        _filteredImageView.contentMode = UIViewContentModeScaleAspectFit;
        _filteredImageView.clipsToBounds = YES;
        _filteredImageView.backgroundColor = self.view.backgroundColor;
        _filteredImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _filteredImageView;
}

- (NSArray *)filterDescriptors {
    if (!_filterDescriptors) {
        _filterDescriptors = @[@[@"CIColorControls", @"None"],
                               @[@"CIPhotoEffectMono", @"Mono"],
                               @[@"CIPhotoEffectTonal", @"Tonal"],
                               @[@"CIPhotoEffectNoir", @"Noir"],
                               @[@"CIPhotoEffectFade", @"Fade"],
                               @[@"CIPhotoEffectChrome", @"Chrome"],
                               @[@"CIPhotoEffectProcess", @"Process"],
                               @[@"CIPhotoEffectTransfer", @"Transfer"],
                               @[@"CIPhotoEffectInstant", @"Instant"]];
    }
    return _filterDescriptors;
}

- (NSMutableArray *)filters {
    if (!_filters) {
        _filters = [NSMutableArray array];
        for (NSArray *arr in self.filterDescriptors) {
            [_filters addObject:[CIFilter filterWithName:arr[0]]];
        }
    }
    return _filters;
}

@end
