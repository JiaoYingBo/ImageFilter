//
//  IFImageEditorToolView.m
//  CasualShop
//
//  Created by 焦英博 on 2017/6/13.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "IFImageEditorToolView.h"
#import "IFFilterToolCell.h"
#import "IFImagePropertyModel.h"
#import "IFImageUtils.h"
#import "IFFilterUtils.h"

@interface IFImageEditorToolView () <UICollectionViewDataSource, UICollectionViewDelegate>

// 滤镜库
@property (nonatomic, strong) UICollectionView *collectionView;
// 记录点击的 滤镜、标签、贴纸 按钮
@property (nonatomic, strong) UIButton *selectedbtn;
// 缩略图
@property (nonatomic, strong) UIImage *thumbnail;
// 滤镜效果缩略图
@property (nonatomic, strong) NSMutableArray *filteredThumbnails;
// 选择的滤镜效果
@property (nonatomic, assign) NSUInteger currentFilterIndex;

@end

@implementation IFImageEditorToolView

#pragma mark - initialize

+ (instancetype)createView {
    IFImageEditorToolView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return view;
}

- (instancetype)init {
    if (self = [super init]) {
        _currentFilterIndex = 0;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.filterLibraryView addSubview:self.collectionView];
    self.selectedbtn = self.filterBtn;
}

#pragma mark - setter

- (void)setOriginalImage:(UIImage *)originalImage {
    if (_originalImage == originalImage) {
        return;
    }
    _originalImage = originalImage;
    
    self.thumbnail = [IFImageUtils thumbnailWithImageWithoutScale:originalImage size:CGSizeMake(100 * [UIScreen mainScreen].scale, originalImage.size.height / originalImage.size.width * 100 * [UIScreen mainScreen].scale)];
}

- (void)setProcessedImage:(UIImage *)processedImage {
    if (_processedImage == processedImage) {
        return;
    }
    _processedImage = processedImage;
}

- (void)setThumbnail:(UIImage *)thumbnail {
    _thumbnail = thumbnail;
    
    // 切换图片后清空滤镜图片
    self.filteredThumbnails = nil;
    
    for (NSInteger i = 0; i < [[IFFilterUtils filterNameArray] count]; i ++) {
        
        IFImagePropertyModel *model = [self.model copy];
        model.selectedFilterIndex = i;
        
        // 传过来的是裁剪原图+单个滤镜，这时只需要把它当原图进行一次列表滤镜就行了，不用再处理全部滤镜，否则就过度处理了
        
        // OpenGL方法，OpenGL滤镜会出现严重内存泄漏
//        UIImage *img = i==0 ? _thumbnail : [IFFilterUtils imageWithImage:_thumbnail withColorMatrix:[IFFilterUtils matrixWithIndex:i]];
//        [self.filteredThumbnails replaceObjectAtIndex:i withObject:img];
//        // 图片全部处理完再刷新
//        if (![self.filteredThumbnails containsObject:@1] && self.window != nil) {
//            [self.collectionView reloadData];
//        }
        
        // CoreImage方法
        [IFFilterUtils filterImage:_thumbnail withFilter:[[IFFilterUtils filterArray] objectAtIndex:i] completion:^(UIImage *img) {
            [self.filteredThumbnails replaceObjectAtIndex:i withObject:img];
            // 图片全部处理完再刷新
            if (![self.filteredThumbnails containsObject:@1] && self.window != nil) {
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)setCurrentFilterIndex:(NSUInteger)currentFilterIndex {
    if (_currentFilterIndex == currentFilterIndex) {
        return;
    }
    _currentFilterIndex = currentFilterIndex;
    [self.collectionView reloadData];
}

- (void)setModel:(IFImagePropertyModel *)model {
    _model = model;
    
    self.currentFilterIndex = model.selectedFilterIndex;
}

#pragma mark - collectionView dataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IFFilterToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.item == self.currentFilterIndex) {
        cell.select = YES;
    } else {
        cell.select = NO;
    }
    
    cell.titleLabel.text = [[IFFilterUtils filterNameArray] objectAtIndex:indexPath.item];
    if ([self.filteredThumbnails[indexPath.item] isKindOfClass:[UIImage class]]) {
        cell.imgView.image = self.filteredThumbnails[indexPath.item];
    } else {
        cell.imgView.image = nil;
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 没有给thumbImage赋值的时候不显示cell
    return self.thumbnail ? [[IFFilterUtils filterNameArray] count] : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentFilterIndex = indexPath.item;
    [self processedImageDelegateInvoke];
}

#pragma mark - delegate invoke

- (void)processedImageDelegateInvoke {
    
    IFImagePropertyModel *model = [self.model copy];
    model.selectedFilterIndex = self.currentFilterIndex;
    [IFFilterUtils processImage:self.processedImage withProperty:model completion:^(UIImage *image) {
        if ([self.delegate respondsToSelector:@selector(imageEditorToolView:didProcessedImage:property:)]) {
            IFImagePropertyModel *model = [[IFImagePropertyModel alloc] init];
            model.selectedFilterIndex = self.currentFilterIndex;
            [self.delegate imageEditorToolView:self didProcessedImage:image property:model];
        }
    }];
}

#pragma mark - actions

// 滤镜、标签、贴纸
- (IBAction)btnClick:(UIButton *)sender {
    [self.selectedbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.selectedbtn = sender;
    
    [self.bottomScroll setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * (sender.tag - 100 - 1), 0) animated:NO];
    
    self.linePositionX.constant = [UIScreen mainScreen].bounds.size.width / 3 * (sender.tag - 100 - 1);
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    
    if ([self.delegate respondsToSelector:@selector(imageEditorToolView:didClickedEditButton:)]) {
        [self.delegate imageEditorToolView:self didClickedEditButton:sender];
    }
}

// 滤镜库、美化照片
- (IBAction)editClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (sender.tag == 1) {
        // 滤镜库
        [self.beautifyPictureBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.filterLibraryView.hidden = NO;
        self.beautifyPictureView.hidden = YES;
    } else if (sender.tag == 2) {
        // 美化照片
        [self.filterLibraryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.filterLibraryView.hidden = YES;
        self.beautifyPictureView.hidden = NO;
    }
}

// 剪裁、亮度、对比度、色温、饱和度
- (IBAction)beautifyClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(imageEditorToolView:didClickedEditButton:)]) {
        [self.delegate imageEditorToolView:self didClickedEditButton:sender];
    }
}

// 活动贴纸、我的贴纸
- (IBAction)stickerClick:(UIButton *)sender {
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (sender.tag == 1) {
        // 活动贴纸
        [self.myStickerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.activityStickerView.hidden = NO;
        self.myStickerView.hidden = YES;
    } else if (sender.tag == 2) {
        // 我的贴纸
        [self.activityStickerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.activityStickerView.hidden = YES;
        self.myStickerView.hidden = NO;
    }
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat scale = width / 375.0;
        CGFloat itemW = 90 * scale;
        CGFloat itemH = 125 * scale;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.sectionInset = UIEdgeInsetsMake(0, 10 * scale, 0, 10 * scale);
        layout.minimumLineSpacing = 10 * scale;
        layout.minimumInteritemSpacing = 15 * scale;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, itemH + 10) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([IFFilterToolCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSMutableArray *)filteredThumbnails {
    if (!_filteredThumbnails) {
        _filteredThumbnails = [NSMutableArray arrayWithCapacity:[IFFilterUtils filterNameArray].count];
        for (int i = 0; i < [IFFilterUtils filterNameArray].count; i ++) {
            [_filteredThumbnails addObject:@1];
        }
    }
    return _filteredThumbnails;
}

@end
