// 滤镜处理顺序：原图-->列表滤镜-->亮度、饱和度、对比度-->色温
// 属性里有原图(originalImage)、原图+裁剪(cuttedOriginalImage)、原图+裁剪+滤镜(processedImage)

//  传入原图后把它进行全部处理然后显示，点击剪裁后，把原图和处理图都进行剪裁，如果图片有标签或贴图，裁剪时全都去掉
// 裁剪完后（把 原图+新裁剪 根据属性按 上述顺序 进行处理，然后）代理回调 新裁剪、新裁剪+滤镜 两个图，修改两个属性
// 这时toolView的原图是 原图+新裁剪，显示图片是 滤镜后的新裁剪图，点击滤镜列表，扔按 上述顺序 进行处理

// 美化照片时，显示图片传入processedImage，处理图片传入cuttedOriginalImage+列表滤镜，并传入该图片的属性模型
// 美化时 亮度、饱和度、对比度、色温 这些属性全都重新处理（这不是个优雅的方法，但目前没有想到别的方法）
// 美化完后代理回调滤镜后的图片，传入processedImage

// 滤镜列表原图是cuttedOriginalImage+单个滤镜，顺序固定
// 点击滤镜列表时cuttedOriginalImage+滤镜列表+单个滤镜顺序处理
// 修改单个滤镜时修改所有效果的图，这样就能让图片可逆

#import "IFEditorViewController.h"
#import "IFEditImageController.h"
#import "IFTextViewController.h"
#import "IFImageCollectionCell.h"
#import "IFImageEditorToolView.h"
#import "IFImagePropertyModel.h"
#import "IFFilterUtils.h"
#import "IFImageUtils.h"

@interface IFEditorViewController () <UICollectionViewDataSource, UICollectionViewDelegate, IFImageEditorToolViewDelegate, IFEditImageControllerDelegate>

// 显示所有图片
@property (nonatomic, strong) UICollectionView *collectionView;
// 图片编辑栏，每次切换图片后给它的originalImage赋值即可刷新滤镜列表图
@property (nonatomic, strong) IFImageEditorToolView *toolView;
// 页面标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 当前显示的图片索引值
@property (nonatomic, assign) NSUInteger currentImageIndex;
// 图片属性集合
@property (nonatomic, strong) NSMutableArray *imagePropertyModels;

@end

@implementation IFEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configDatas];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTouchBegin) name:@"IFTextViewTouchBegin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTouchEnd) name:@"IFTextViewTouchEnd" object:nil];
}

- (void)configDatas {
    self.currentImageIndex = 0;
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.originalImagesArray.count];
    for (UIImage *img in self.originalImagesArray) {
        [temp addObject:[self reduceImage:img]];
    }
    self.originalImagesArray = [temp copy];
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    if (self.selectIndex != 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self scrollViewDidEndDecelerating:self.collectionView];
    }
    
    [self.view addSubview:self.toolView];
    self.titleLabel.text = [NSString stringWithFormat:@"编辑图片 (%td/%td)", self.currentImageIndex + 1, self.originalImagesArray.count];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"image editor dealloc");
}

#pragma mark - private method

- (void)textViewTouchBegin {
    self.collectionView.scrollEnabled = NO;
}

- (void)textViewTouchEnd {
    self.collectionView.scrollEnabled = YES;
    
    IFImagePropertyModel *model = self.imagePropertyModels[self.currentImageIndex];
    IFImageCollectionCell *cell = (IFImageCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]];
    CGRect frame = [cell.textView convertRect:cell.textView.titleLabel.frame toView:cell.imageView];
    CGFloat scale = cell.imageView.image.size.width / cell.imageView.bounds.size.width;
    model.textFrame = frame;
    model.scale = scale;
}

#pragma mark - override

// 取消
- (IBAction)cancelClick:(UIButton *)sender {
    [self backClick];
}

// 继续
- (IBAction)continueClick:(UIButton *)sender {
    [self goOnClick];
    
    for (NSInteger i = 0; i < self.imagePropertyModels.count; i ++) {
        IFImagePropertyModel *model = self.imagePropertyModels[i];
        NSLog(@"%@",model);
    }
    // 然后重新绘制有文字的图片
    
//    IFImageCollectionCell *cell = (IFImageCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]];
//    CGRect frame = [cell.textView convertRect:cell.textView.titleLabel.frame toView:cell.imageView];
//    CGFloat scale = cell.imageView.image.size.width / cell.imageView.bounds.size.width;
//    cell.imageView.image = [IFImageUtils redrawImageWith:cell.imageView.image text:@"哈哈" frame:frame scale:scale];
}

- (void)goOnClick {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(editorViewController:processedImages:)]) {
            // 取出处理过的图片回调传值
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.imagePropertyModels.count];
            for (IFImagePropertyModel *model in self.imagePropertyModels) {
                [array addObject:model.processedImage];
            }
            [self.delegate editorViewController:self processedImages:[array copy]];
        }
    }];
}

#pragma mark - collectionView dataSource & delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // cell不重用
    NSString * stringID = [NSString stringWithFormat:@"CookingEquipmentCellId%ld",indexPath.row];
    IFImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringID forIndexPath:indexPath];
    IFImagePropertyModel *model = self.imagePropertyModels[indexPath.item];
    cell.imageView.image = model.processedImage;
    if (model.borderHidden) {
        [cell.textView setBorderHidden:YES];
    } else {
        [cell.textView setBorderHidden:NO];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagePropertyModels.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger offsetX = self.toolView.bottomScroll.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    if (offsetX != 1) {
        return;
    }
//    IFTextViewController *textVC = [[IFTextViewController alloc] init];
//    textVC.text = ^(NSString *string) {
//        IFImageCollectionCell *cell = (IFImageCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]];
//        
//        if ([string isEqualToString:@""]) {
//            cell.textView.text = string;
//            [cell.textView setBorderHidden:YES];
//            return;
//        }
//        cell.textView.text = string;
//        IFImagePropertyModel *model = self.imagePropertyModels[self.currentImageIndex];
//        model.text = string;
//        [cell.textView setBorderHidden:NO];
//        
//        CGRect frame = [cell.textView convertRect:cell.textView.titleLabel.frame toView:cell.imageView];
//        CGFloat scale = cell.imageView.image.size.width / cell.imageView.bounds.size.width;
//        model.textFrame = frame;
//        model.scale = scale;
//    };
//    [self presentViewController:textVC animated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentImageIndex = (NSInteger)(scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width+10));
}

#pragma mark - actions

// 点击滤镜库效果
- (void)imageEditorToolView:(IFImageEditorToolView *)editor didProcessedImage:(UIImage *)image property:(IFImagePropertyModel *)model {
    // image:滤镜处理后的图片
    // model:返回model.selectedFilterIndex，其它属性都是初始属性，不需要
    // 修改model中的processedImage和selectedFilterIndex
    IFImagePropertyModel *tempModel = self.imagePropertyModels[self.currentImageIndex];
    
    tempModel.processedImage = image;
    tempModel.selectedFilterIndex = model.selectedFilterIndex;
    [self.imagePropertyModels replaceObjectAtIndex:self.currentImageIndex withObject:tempModel];
    
    // 刷新图片显示
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]]];
}

// 工具栏按钮点击
- (void)imageEditorToolView:(IFImageEditorToolView *)editor didClickedEditButton:(UIButton *)button {
    if (button.tag < 100) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        IFImagePropertyModel *model = self.imagePropertyModels[self.currentImageIndex];
        UIImage *img = model.processedImage;
        IFEditImageController *editVC = [[IFEditImageController alloc] init];
        
        if (button.tag == 1) {
            // 剪裁
            editVC.editType = IFEditTypeCutting;
            img = self.originalImagesArray[self.currentImageIndex];
        } else if (button.tag == 2) {
            // 亮度
            editVC.editType = IFEditTypeBrightness;
            editVC.processedImage = model.cuttedOriginalImage;
        } else if (button.tag == 3) {
            // 对比度
            editVC.editType = IFEditTypeContrast;
            editVC.processedImage = model.cuttedOriginalImage;
        } else if (button.tag == 4) {
            // 色温
            editVC.editType = IFEditTypeColorTemperature;
            editVC.processedImage = model.cuttedOriginalImage;
        } else if (button.tag == 5) {
            // 饱和度
            editVC.editType = IFEditTypeSaturation;
            editVC.processedImage = model.cuttedOriginalImage;
        }
        
        editVC.editImageView.frame = self.collectionView.frame;
        editVC.image = img;
        editVC.editView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), width, height - CGRectGetHeight(self.collectionView.frame) - 44);
        editVC.delegate = self;
        editVC.model = model;
        // 点击“取消”和“继续”按钮block回调
        editVC.navBtnClick = ^(NSInteger tag) {
            if (tag == 1) {// 取消
                [self backClick];
            } else if (tag == 2) {// 继续
                [self goOnClick];
                NSLog(@"代理回调全部图片");
            }
        };
        [self presentViewController:editVC animated:NO completion:nil];
        
    } else {
        for (NSInteger i = 0; i < self.imagePropertyModels.count; i ++) {
            IFImagePropertyModel *model = self.imagePropertyModels[i];
            model.borderHidden = YES;
            
            if (model.text != nil && ![model.text isEqualToString:@""]) {
                IFImageCollectionCell *cell = (IFImageCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                if (button.tag == 101) {
                    // 滤镜
                    [cell.textView setBorderHidden:YES];
                    model.borderHidden = YES;
                } else if (button.tag == 102) {
                    // 标签
                    // 除了正在显示的cell，其它cell都是nil，所以该操作只会让正在显示的cell文字隐藏边框
                    [cell.textView setBorderHidden:NO];
                    model.borderHidden = NO;
                } else if (button.tag == 103) {
                    // 贴纸
                    [cell.textView setBorderHidden:YES];
                    model.borderHidden = YES;
                }
            }
        }
        [self.collectionView reloadData];
    }
}

#pragma mark - editImageController delegate

// 美化照片回调
- (void)editImageController:(IFEditImageController *)editController didProcessedImage:(UIImage *)image property:(IFImagePropertyModel *)model originalCuttedImage:(UIImage *)oriCuttedImg {
    // image是滤镜图片+裁剪原图
    // oriCuttedImg是裁剪原图
    IFImagePropertyModel *tempModel = self.imagePropertyModels[self.currentImageIndex];
    
    if (editController.editType == IFEditTypeCutting) {
        tempModel.cuttedOriginalImage = oriCuttedImg;
        tempModel.processedImage = image;
        [self.imagePropertyModels replaceObjectAtIndex:self.currentImageIndex withObject:tempModel];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]]];
//        [IFFilterUtils filterImage:oriCuttedImg withProperty:tempModel completion:^(UIImage *image) {
//            // 滤镜列表原图显示裁剪原图+滤镜
//            self.toolView.originalImage = image;
//            // 处理图是裁剪原图
//            self.toolView.processedImage = oriCuttedImg;
//        }];
        return;
    } else if (editController.editType == IFEditTypeBrightness) {
        tempModel.brightnessValue = model.brightnessValue;
        tempModel.brightnessSliderValue = model.brightnessSliderValue;
        tempModel.processedImage = image;
    } else if (editController.editType == IFEditTypeContrast) {
        tempModel.contrastValue = model.contrastValue;
        tempModel.contrastSliderValue = model.contrastSliderValue;
        tempModel.processedImage = image;
    } else if (editController.editType == IFEditTypeColorTemperature) {
        tempModel.colorTemperatureValue = model.colorTemperatureValue;
        tempModel.colorTemperatureSliderValue = model.colorTemperatureSliderValue;
        tempModel.processedImage = image;
    } else if (editController.editType == IFEditTypeSaturation) {
        tempModel.saturationValue = model.saturationValue;
        tempModel.saturationSliderValue = model.saturationSliderValue;
        tempModel.processedImage = image;
    }
    [self.imagePropertyModels replaceObjectAtIndex:self.currentImageIndex withObject:tempModel];
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0]]];
    
//    [IFFilterUtils filterImage:tempModel.cuttedOriginalImage withProperty:tempModel completion:^(UIImage *image) {
//        // 滤镜列表原图显示裁剪原图+单个滤镜
//        self.toolView.originalImage = image;
//        // 处理图是裁剪原图
//        self.toolView.processedImage = tempModel.cuttedOriginalImage;
//    }];
}

#pragma mark - setter

- (void)setOriginalImagesArray:(NSArray *)originalImagesArray {
    _originalImagesArray = originalImagesArray;
    
    // 初始化属性模型
    NSInteger count = originalImagesArray.count;
    _imagePropertyModels = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i ++) {
        IFImagePropertyModel *model = [[IFImagePropertyModel alloc] init];
        model.originalImage = originalImagesArray[i];
        model.cuttedOriginalImage = originalImagesArray[i];
        model.processedImage = originalImagesArray[i];
        [_imagePropertyModels addObject:model];
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"编辑图片 (%td/%td)", self.currentImageIndex + 1, _originalImagesArray.count];
    [self.collectionView reloadData];
}

- (void)setCurrentImageIndex:(NSUInteger)currentImageIndex {
    if (_currentImageIndex == currentImageIndex) { return; }
    _currentImageIndex = currentImageIndex;
    
    self.titleLabel.text = [NSString stringWithFormat:@"编辑图片 (%td/%td)", self.currentImageIndex + 1, self.imagePropertyModels.count];
    
    self.toolView.originalImage = self.originalImagesArray[_currentImageIndex];
    self.toolView.model = self.imagePropertyModels[_currentImageIndex];
    self.toolView.processedImage = self.originalImagesArray[_currentImageIndex];
}

//#pragma mark - 贴图 delegate
//
//- (void)chartletToolView:(IFChartletToolView *)chartlet didSelectedImage:(UIImage *)image {
//    self.chartletSelectedImg = image;
//}
//
//- (void)chartletToolView:(IFChartletToolView *)chartlet didClickedButton:(UIButton *)button {
//    self.chartletImg = [[IFImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
//    self.chartletImg.imgView.image = self.chartletSelectedImg;
//    [self.imgView addSubview:self.chartletImg];
//
//    [self.chartletView dismiss];
//    self.chartletView = nil;
//}

#pragma mark - 图片处理

// 过大的图片处理成小图，以免处理时间太长
- (UIImage *)reduceImage:(UIImage *)image {
    CGFloat ratio = image.size.height / image.size.width;
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 2;
    if (image.size.width > width) {
        CGSize size = CGSizeMake(width, width * ratio);
        return [IFImageUtils thumbnailWithImageWithoutScale:image size:size];
    }
    return image;
}

#pragma mark - lazy load

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat scale = width / 375.0;
        CGFloat height = width < 375 ? 370 * scale : 400 * scale;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(width + 15, height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, width + 15, height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        for (NSInteger i = 0; i < 9; i++) {
            NSString * stringID = [NSString stringWithFormat:@"CookingEquipmentCellId%ld",i];
            [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([IFImageCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:stringID];
        }
    }
    return _collectionView;
}

- (IFImageEditorToolView *)toolView {
    if (!_toolView) {
        _toolView = [IFImageEditorToolView createView];
        _toolView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-CGRectGetHeight(self.collectionView.frame)-44);
        
        _toolView.model = self.imagePropertyModels[self.currentImageIndex];
        _toolView.originalImage = self.originalImagesArray[self.currentImageIndex];
        _toolView.processedImage = self.originalImagesArray[self.currentImageIndex];
        _toolView.delegate = self;
    }
    return _toolView;
}

- (NSMutableArray *)imagePropertyModels {
    if (!_imagePropertyModels) {
        NSInteger count = self.originalImagesArray.count ? : 9;
        _imagePropertyModels = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i ++) {
            IFImagePropertyModel *model = [[IFImagePropertyModel alloc] init];
            [_imagePropertyModels addObject:model];
        }
    }
    return _imagePropertyModels;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
