//
//  FilterListViewController.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "FilterListViewController.h"
#import "FilterDetailViewController.h"
#import "SelectImageController.h"

@interface FilterListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *filters;

@end

@implementation FilterListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
}

#pragma mark - UI

- (void)setupUI {
    self.navigationItem.title = @"Core Image Filters";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"选择图片" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = item;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.view layoutIfNeeded];
}

#pragma mark - tableview datasource & delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.filters[indexPath.row][1];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filters.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FilterDetailViewController *vc = [[FilterDetailViewController alloc] init];
    vc.filterName = self.filters[indexPath.row][0];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - actions

- (void)rightClick {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    SelectImageController *select = [[SelectImageController alloc] init];
    window.rootViewController = select;
    [UIView animateWithDuration:1 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
    }];
}

#pragma mark - getter

- (NSArray *)filters {
    if (!_filters) {
        _filters = @[@[@"CIBloom", @"Bloom"],
                     @[@"CIColorControls", @"Color Controls"],
                     @[@"CIColorInvert", @"Color Invert"],
                     @[@"CIColorPosterize", @"Color Posterize"],
                     @[@"CIExposureAdjust", @"Exposure Adjust"],
                     @[@"CIGammaAdjust", @"Gamma Adjust"],
                     @[@"CIGaussianBlur", @"Gaussian Blur"],
                     @[@"CIGloom", @"Gloom"],
                     @[@"CIHighlightShadowAdjust", @"Highlights and Shadows"],
                     @[@"CIHueAdjust", @"Hue Adjust"],
                     @[@"CILanczosScaleTransform", @"Lanczos Scale Transform"],
                     @[@"CIMaximumComponent", @"Maximum Component"],
                     @[@"CIMinimumComponent", @"Minimum Component"],
                     @[@"CISepiaTone", @"Sepia Tone"],
                     @[@"CISharpenLuminance", @"Sharpen Luminance"],
                     @[@"CIStraightenFilter", @"Straighten"],
                     @[@"CIUnsharpMask", @"Unsharp Mask"],
                     @[@"CIVibrance", @"Vibrance"],
                     @[@"CIVignette", @"Vignette"]];
    }
    return _filters;
}

@end
