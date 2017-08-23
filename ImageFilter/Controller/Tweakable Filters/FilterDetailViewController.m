//
//  FilterDetailViewController.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "FilterDetailViewController.h"
#import "FilteredImageView.h"
#import "ParameterAdjustmentView.h"

@interface FilterDetailViewController ()

@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) FilteredImageView *filteredImageView;
@property (nonatomic, strong) ParameterAdjustmentView *parameterAdjustmentView;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation FilterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.filter = [CIFilter filterWithName:self.filterName];
    self.navigationItem.title = self.filterName;
    [self addSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
    
    [self applyConstraintsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self applyConstraintsForInterfaceOrientation:toInterfaceOrientation];
}

- (NSArray *)filterParameterDescriptors {
    NSArray *inputNames = [self.filter inputKeys];
    
    NSDictionary *attributes = self.filter.attributes;
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *inputName in inputNames) {
        if (![inputName isEqualToString:@"inputImage"]) {
            
            NSDictionary *attribute = attributes[inputName];
            NSString *displayName = [inputName substringFromIndex:5];
            CGFloat minValue = [attribute[kCIAttributeSliderMin] floatValue];
            CGFloat maxValue = [attribute[kCIAttributeSliderMax] floatValue];
            CGFloat defaultValue = [attribute[kCIAttributeDefault] floatValue];
            
            ScalarFilterParameter *param = [[ScalarFilterParameter alloc] initWithName:displayName key:inputName minimumValue:minValue maximumValue:maxValue currentValue:defaultValue];
            [array addObject:param];
        }
    }
    return array;
}

- (void)addSubviews {
    self.filteredImageView = [[FilteredImageView alloc] initWithFrame:self.view.bounds];
    self.filteredImageView.inputImage = source_image;
    self.filteredImageView.filter = self.filter;
    self.filteredImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.filteredImageView.clipsToBounds = YES;
    self.filteredImageView.backgroundColor = self.view.backgroundColor;
    self.filteredImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.filteredImageView];
    
    self.parameterAdjustmentView = [[ParameterAdjustmentView alloc] initWithFrame:self.view.bounds parameters:[self filterParameterDescriptors]];
    self.parameterAdjustmentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.parameterAdjustmentView setAdjustmentDelegate:self.filteredImageView];
    [self.view addSubview:self.parameterAdjustmentView];
}

- (void)applyConstraintsForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [self.view removeConstraints:self.constraints];
    [self.constraints removeAllObjects];
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-66]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.parameterAdjustmentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.parameterAdjustmentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.parameterAdjustmentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.parameterAdjustmentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    } else {
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.filteredImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.parameterAdjustmentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.parameterAdjustmentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:-85]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.parameterAdjustmentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.constraints addObject:[NSLayoutConstraint constraintWithItem:self.parameterAdjustmentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    }
    [self.view addConstraints:[self.constraints copy]];
}

- (NSMutableArray *)constraints {
    if (!_constraints) {
        _constraints = [NSMutableArray array];
    }
    return _constraints;
}

@end
