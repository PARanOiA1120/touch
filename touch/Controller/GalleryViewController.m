//
//  GalleryViewController.m
//  touch
//
//  Created by zhu on 1/26/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//
#import "GalleryViewController.h"
#import "GalleryViewCell.h"
#import "CameraViewController.h"
#import "GalleryDropView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <Photos/Photos.h>
#import "DRNRealTimeBlurView.h"
#import "TopPopView.h"
#import <FCVerticalMenu.h>
#import "ImageBrowserViewController.h"
#import "PhotoBrowserViewController.h"
#import "NewActivityViewController.h"

#define PHOTO_LIMIT             4

typedef void (^VoidBlock) (void);
typedef void (^IntegerBlock) (NSInteger);

static NSString * reuseIdentifier = @"reuseCell";
static NSString * reuseViewIndenfier = @"reuseView";

@interface GalleryViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
GalleryViewCellDelegate,
GalleryDropViewDelegate,
TopPopViewDelegate,
PhotoBrowserViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *titleArrowView;
@property (strong, nonatomic) FCVerticalMenu *verticalMenu;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) GalleryDropView *dropView;

@property (strong, nonatomic) UIButton *originButton;
@property (strong, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) UIView *sizeView;
@property (strong, nonatomic) UIActivityIndicatorView *sizeProgressView;
@property (strong, nonatomic) UILabel *sizeLabel;

@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSMutableArray *mutableArray;
@property (strong, nonatomic) NSMutableArray *selectionList;
@property (strong, nonatomic) NSMutableArray *selectedImages;


@property (nonatomic) dispatch_queue_t imageQueue;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (nonatomic) NSUInteger assetsGroupCount;

@property (strong, nonatomic) ALAssetsGroup *assetsGroup;

@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSMutableArray *groups;
@property (strong, nonatomic) ALAssetsFilter *assetsFilter;

@property (nonatomic) BOOL useOriginalImage;
@end
@implementation GalleryViewController

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t onceToken = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&onceToken, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (id)initWithSelectedImages:(NSArray *)list {
    self = [super init];
    if (self) {
        //        self.selectionList = [NSMutableArray arrayWithCapacity:list.count];
        //        for (NSNumber *number in list) {
        //            [_selectionList addObject:@([number integerValue] + 1)];
        //        }
        self.selectedImages = [list mutableCopy];
    }
    return self;
}

- (id)initWithImages:(NSArray *)images {
    self = [super init];
    if (self) {
        self.selectedImages = [images mutableCopy];
    }
    return self;
}

/*
 - (UIStatusBarStyle) preferredStatusBarStyle {
 return UIStatusBarStyleDefault;
 }*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (!_selectedImages) {
        self.selectedImages = [[NSMutableArray alloc] init];
    }
    [_collectionView registerNib:[UINib nibWithNibName:@"GalleryViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    //[self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.imageQueue = dispatch_queue_create("image queue", DISPATCH_QUEUE_SERIAL);
    
    self.assetsFilter = [ALAssetsFilter allPhotos];
    [self configureNavigationBar];
    [self configureButtonView];
    UIButton *abutton = [[UIButton alloc] init];
    abutton.frame = CGRectMake(0, 0, 10, 10);
    [self.view addSubview:abutton];
    //NSLog(@"can you");
    
    //    _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 10);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.footerReferenceSize = CGSizeMake(SCREENWIDTH, 50.0);
    layout.itemSize = CGSizeMake((SCREENWIDTH - 50) / 3, (SCREENWIDTH - 50) / 3);
    _collectionView.collectionViewLayout = layout;
    _collectionView.backgroundColor = [UIColor blackColor];
    if (_selectionList == nil) {
        self.selectionList = [[NSMutableArray alloc] init];
    }
    [self getAssetsGroup:^{}
          withSetupAsset:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)configureButtonView
{
    
    CGRect bounds = self.buttonView.bounds;
    self.buttonView.clipsToBounds = YES;
    CGRect visualRect = [[UIScreen mainScreen] bounds];
    CGFloat buttonWidth = 60;
    CGFloat buttonHeight = 30;
    UIButton *originImageButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, (50 - buttonHeight) / 2, buttonWidth, buttonHeight)];
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(visualRect.size.width - 20 - buttonWidth, (50 - buttonHeight) / 2, buttonWidth, buttonHeight)];
    [originImageButton addTarget:self action:@selector(selectedOriginalImageQuality) forControlEvents:UIControlEventTouchUpInside];
    [nextStepButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [originImageButton setTitle:@"原图" forState:UIControlStateNormal];
    [nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    originImageButton.titleLabel.textColor = [UIColor whiteColor];
    nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    [originImageButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    originImageButton.imageEdgeInsets = UIEdgeInsetsMake(7.0, 0.0, 7.0, 44.0);
    originImageButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 4.0, 0.0, 0.0);
    nextStepButton.enabled = _selectedImages.count > 0;
    
    // 显示原图尺寸
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(25.0 + buttonWidth, (50.0 - buttonHeight) / 2, 60.0, buttonHeight)];
    self.sizeView = view;
    UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 5.0, 20.0, 20.0)];
    [view addSubview:progressView];
    self.sizeProgressView = progressView;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 35.0, 20.0)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    self.sizeLabel = label;
    _sizeView.hidden = YES;
    if (_useOriginalImage) {
        [originImageButton setImage:[UIImage imageNamed:@"photo_selected.png"] forState:UIControlStateNormal];
    } else {
        [originImageButton setImage:[UIImage imageNamed:@"photo_unselected.png"] forState:UIControlStateNormal];
    }
    self.originButton = originImageButton;
    self.nextButton = nextStepButton;
    
    if (IOS8_UP)
    {
        self.buttonView.backgroundColor = [UIColor colorWithRed:0.32f green:0.32f blue:0.32f alpha:0.10f];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = bounds;
        visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        vibrancyView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
        vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //configure button
        [vibrancyView addSubview:originImageButton];
        [vibrancyView addSubview:nextStepButton];
        [vibrancyView addSubview:view];
        [visualEffectView.contentView addSubview:vibrancyView];
        [self.buttonView addSubview:visualEffectView];
    }
    if (IOS7)
    {
        self.buttonView.backgroundColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:1.0f];
        //self.buttonView.backgroundColor = [UIColor clearColor];
        DRNRealTimeBlurView *blur = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(0, 0, visualRect.size.width, 50) tintColor:[UIColor clearColor]];
        [blur addSubview:originImageButton];
        [blur addSubview:nextStepButton];
        blur.renderStatic = NO;
        [self.buttonView addSubview:blur];
        [_buttonView addSubview:view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedOriginalImageQuality
{
    self.useOriginalImage = !_useOriginalImage;
    if (_useOriginalImage) {
        [_originButton setImage:[UIImage imageNamed:@"photo_selected.png"] forState:UIControlStateNormal];
    } else {
        [_originButton setImage:[UIImage imageNamed:@"photo_unselected.png"] forState:UIControlStateNormal];
    }
    [self calculateSizeOfOriginalImage];
}

//下一步
- (void)nextStep
{
    NSLog(@"next step");
    if ([_delegate respondsToSelector:@selector(galleryController:didChooseImages:forIndex:)]) {
        [_delegate galleryController:self didChooseImages:_selectedImages forIndex:nil];
    }
    if (_fromType == GalleryFromTypeCreateActivity) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else if (_fromType == GalleryFromTypeHome) {
        //        NewActivityViewController *newController = [[NewActivityViewController alloc] initWithImages:_selectedImages];
        //        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newController];
        if ([_delegate respondsToSelector:@selector(galleryController:shouldChangeToActivityCreationControllerWithImages:)]) {
            [_delegate galleryController:self shouldChangeToActivityCreationControllerWithImages:_selectedImages];
        }
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void) addBlurEffect {
    
    // Add blur view
    CGRect bounds = self.navigationController.navigationBar.bounds;
    //vibrancy
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    if (IOS8_UP)
    {
        UIColor *color = [UIColor colorWithRed:0.32f green:0.32f blue:0.32f alpha:0.10f];
        UIImage *image = [self imageWithColor:color];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //NSLog(@"y = %f",self.navigationController.navigationBar.bounds.origin.y);
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setTranslucent:YES];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = CGRectMake(bounds.origin.x, bounds.origin.y - statusBarFrame.size.height, bounds.size.width, bounds.size.height + statusBarFrame.size.height);
        
        visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        vibrancyView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height + statusBarFrame.size.height);
        vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [visualEffectView.contentView addSubview:vibrancyView];
        
        [self.navigationController.navigationBar addSubview:visualEffectView];
    }
    if (IOS7)
    {
        UIColor *color = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:1.0f];
        UIImage *image = [self imageWithColor:color];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //NSLog(@"y = %f",self.navigationController.navigationBar.bounds.origin.y);
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setTranslucent:YES];
        
        DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y - statusBarFrame.size.height, bounds.size.width, bounds.size.height + statusBarFrame.size.height) tintColor:[UIColor clearColor]];
        blurView.renderStatic = NO;
        [self.navigationController.navigationBar addSubview:blurView];
    }
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    // Here you can add visual effects to any UIView control.
    // Replace custom view with navigation bar in above code to add effects to custom view.
}

- (void)configureNavigationBar {
    [self addBlurEffect];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"全部";
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.size.width = 100.0;
    label.frame = frame;
    self.titleLabel = label;
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0.0, 0.0, 100.0, frame.size.height + 6.0);
    [titleButton addTarget:self action:@selector(titleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    titleButton.titleLabel.textColor = [UIColor whiteColor];
    [titleButton addSubview:label];
    self.navigationItem.titleView = titleButton;
    self.titleButton = titleButton;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45.0, frame.size.height, 10.0, 6.0)];
    imageView.image = [UIImage imageNamed:@"gallery_arrow_down.png"];
    [titleButton addSubview:imageView];
    self.titleArrowView = imageView;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonDidClick:)];
    [buttonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject: [UIColor whiteColor]
                                                                   forKey: NSForegroundColorAttributeName] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = buttonItem;
    buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(browerButtonDidClick:)];
    [buttonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject: [UIColor whiteColor]
                                                                   forKey: NSForegroundColorAttributeName] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)titleButtonDidClick:(UIButton *)button {
    if (!_dropView) {
        GalleryDropView *dropView = [[GalleryDropView alloc] initWithFrame:self.view.frame];
        dropView.liveBlurTintColor = [UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:1.0];
        dropView.delegate = self;
        self.dropView = dropView;
        __weak UIImageView *arrowView = _titleArrowView;
        [_dropView setShowBlock:^{
            arrowView.transform = CGAffineTransformRotate(arrowView.transform, -M_PI);
        }];
        [_dropView setHideBlock:^{
            arrowView.transform = CGAffineTransformRotate(arrowView.transform, M_PI);
        }];
    }
    if (_dropView.isShown) {
        [_dropView hideFromNavigationBar:self.navigationController.navigationBar];
    } else {
        //        [_dropView showInView:self.navigationController.view];
        [_dropView showFromNavigationBar:self.navigationController.navigationBar inView:self.navigationController.view];
        NSInteger index = [_groups indexOfObject:_assetsGroup];
        [_dropView setCurrentIndex:index];
    }
}

- (void)cancelButtonDidClick:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}

//这里应该是预览，我已经将下一步button改成这个function的功能了
- (void)doneButtonDidClick:(UIBarButtonItem *)item {
    //    NSMutableArray *images = [NSMutableArray array];
    //    NSMutableArray *indexes = [NSMutableArray array];
    //    for (NSNumber *number in _selectionList) {
    //        NSInteger index = [number integerValue] - 1;
    //        [images addObject:_imageArray[index]];
    //        [indexes addObject:@(index)];
    //    }
    
    if ([_delegate respondsToSelector:@selector(galleryController:didChooseImages:forIndex:)]) {
        [_delegate galleryController:self didChooseImages:_selectedImages forIndex:nil];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)browerButtonDidClick:(UIBarButtonItem *)buttonItem {
    //    ImageBrowserViewController *browserController = [[ImageBrowserViewController alloc] initWithImages:_selectedImages];
    PhotoBrowserViewController *browserController = [[PhotoBrowserViewController alloc] initWithImages:_selectedImages];
    browserController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:browserController];
    [self.navigationController presentViewController:navController animated:YES completion:^{
        
    }];
}

// 获取图片分组
- (void)getAssetsGroup:(VoidBlock)endBlock withSetupAsset:(BOOL)doSetupAsset {
    if (!_assetsLibrary) {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    if (!_groups) {
        self.groups = [[NSMutableArray alloc] init];
    } else {
        [_groups removeAllObjects];
    }
    
    __weak typeof(self) weakSelf = self;
    ALAssetsFilter *assetsFilter = _assetsFilter;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:assetsFilter];
            NSInteger groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
            if (groupType == ALAssetsGroupSavedPhotos) {
                [weakSelf.groups insertObject:group atIndex:0];
                if (doSetupAsset) {
                    weakSelf.assetsGroup = group;
                    [weakSelf getAssets:nil];
                }
            } else {
                if ([group numberOfAssets] > 0) {
                    [weakSelf.groups addObject:group];
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新分组数据
                if (endBlock) {
                    endBlock();
                }
            });
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
    };
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:resultBlock failureBlock:failureBlock];
}

// 获取当前组中的图片
- (void)getAssets:(VoidBlock)successBlock {
    NSString *titleName = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    //    [_titleButton setTitle:titleName forState:UIControlStateNormal];
    _titleLabel.text = titleName;
    if (!_assets) {
        self.assets = [[NSMutableArray alloc] init];
    } else {
        [_assets removeAllObjects];
    }
    
    if (!_assetsGroup) {
        self.assetsGroup = _groups[0];
    }
    [_assetsGroup setAssetsFilter:_assetsFilter];
    ALAssetsGroupEnumerationResultsBlock resultBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            [_assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            if ([type isEqualToString:ALAssetTypePhoto]) {
                
            }
            if ([type isEqualToString:ALAssetTypeVideo]) {
                
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新数据
                [self reloadData];
                if (successBlock) {
                    successBlock();
                }
            });
        }
    };
    [_assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:resultBlock];
}

// 计算原图总共大小
- (void)calculateSizeOfOriginalImage {
    if (_useOriginalImage && _selectedImages.count > 0) {
        _sizeView.hidden = NO;
        _sizeProgressView.hidden = NO;
        _sizeLabel.hidden = YES;
        [_sizeProgressView startAnimating];
        __block unsigned long long size = 0;
        ALAssetsLibrary *library = [self.class defaultAssetsLibrary];
        [_selectedImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [library assetForURL:[NSURL URLWithString:obj]
                     resultBlock:^(ALAsset *asset) {
                         if (asset) {
                             ALAssetRepresentation *reprenentation = [asset defaultRepresentation];
                             size += [reprenentation size];
                         }
                         if (idx >= _selectedImages.count - 1) {
                             _sizeProgressView.hidden = YES;
                             _sizeLabel.hidden = NO;
                             _sizeLabel.text = [NSString stringWithFormat:@"%.1fM", size / (1024 * 1024.0)];
                         }
                     }
                    failureBlock:^(NSError *error) {
                    }];
        }];
    } else {
        _sizeView.hidden = YES;
    }
}

- (void)reloadData {
    [_collectionView reloadData];
}

- (BOOL)containsImage:(NSString *)path {
    __block BOOL result = NO;
    [_selectedImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *urlString = [NSString stringWithFormat:@"%@", obj];
        if ([path isEqualToString:urlString]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}


#pragma mark -- Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assets.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"capture_view.png"];
        cell.selectButton.hidden = YES;
    } else {
        cell.selectButton.hidden = NO;
        ALAsset *asset = _assets[indexPath.row - 1];
        cell.imageAsset = asset;
        NSString *imagePath = [[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
        if ([self containsImage:imagePath]) {
            cell.isSelected = YES;
        } else {
            cell.isSelected = NO;
        }
    }
    return cell;
}

#pragma mark -- Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        CameraViewController *cameraController = [[CameraViewController alloc] init];
        //        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cameraController];
        //        [self.navigationController presentViewController:navController animated:YES completion:^{}];
        [self.navigationController pushViewController:cameraController animated:YES];
    } else {
        NSURL *url = [_assets[row - 1] valueForProperty:ALAssetPropertyAssetURL];
        NSString *path = [url absoluteString];
        PhotoBrowserViewController *browserController = [[PhotoBrowserViewController alloc] initWithSingleImage:path];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:browserController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
            
        }];
    }
}

#pragma mark -- Gallery view cell delegate
- (BOOL)galleryCellCanSelectMorePhoto:(GalleryViewCell *)cell {
    NSUInteger limit = _photoCountLimit == 0 ? PHOTO_LIMIT : _photoCountLimit;
    return _selectedImages.count < limit;
}

- (void)shouldShowAlertView:(GalleryViewCell *)view {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"最多只能选择4张照片"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didSelectCell:(GalleryViewCell *)cell {
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    ALAsset *asset = _assets[indexPath.row - 1];
    NSURL *url = [asset valueForProperty:ALAssetPropertyAssetURL];
    [_selectedImages addObject:url.absoluteString];
    _nextButton.enabled = _selectedImages.count > 0;
    [self calculateSizeOfOriginalImage];
}

- (void)didUnselectCell:(GalleryViewCell *)cell {
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    ALAsset *asset = _assets[indexPath.row - 1];
    NSURL *url = [asset valueForProperty:ALAssetPropertyAssetURL];
    [_selectedImages removeObject:url.absoluteString];
    _nextButton.enabled = _selectedImages.count + 0;
    [self calculateSizeOfOriginalImage];
}

#pragma mark -- GalleryDropViewDelegate

- (void)galleryDropView:(GalleryDropView *)view didSelecIndex:(NSUInteger)index {
    self.assetsGroup = _groups[index];
    [self getAssets:nil];
}

- (NSArray *)resourceForGalleryDropView:(GalleryDropView *)view {
    return _groups;
}

#pragma mark -- TopPopViewDelegate

- (NSInteger)numberOfItemsInPopView:(TopPopView *)popView {
    return _groups.count;
}

- (UIImage *)popView:(TopPopView *)popView imageAtIndex:(NSInteger)index {
    ALAssetsGroup *group = _groups[index];
    return [UIImage imageWithCGImage:group.posterImage];
}

- (NSString *)popView:(TopPopView *)popView titleAtIndex:(NSInteger)index {
    ALAssetsGroup *group = _groups[index];
    return [group valueForProperty:ALAssetsGroupPropertyName];
}

- (void)popView:(TopPopView *)popView didSelectItemAtIndex:(NSInteger)index {
    self.assetsGroup = _groups[index];
    NSLog(@"group name : %@", [_assetsGroup valueForProperty:ALAssetsGroupPropertyName]);
    [self getAssets:nil];
}

#pragma mark -- PhotoBrowserViewControllerDelegate

- (void)browserController:(PhotoBrowserViewController *)controller didCloseWithImages:(NSArray *)images {
    self.selectedImages = [images mutableCopy];
    [self reloadData];
}

@end
