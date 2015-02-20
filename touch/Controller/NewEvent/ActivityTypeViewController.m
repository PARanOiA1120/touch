//
//  ActivityTypeViewController.m
//  touch
//
//  Created by zhu on 1/26/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "ActivityTypeViewController.h"
#import "ActivityTypeCell.h"
#import "CommonDefine.h"

@interface ActivityTypeViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

static NSString *reuseIdentifier = @"typeCell";
@implementation ActivityTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup   loading the view from its nib.
    [_collectionView registerNib:[UINib nibWithNibName:@"ActivityTypeCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    _collectionView.allowsMultipleSelection = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(SCREENWIDTH / 3, SCREENWIDTH / 3);
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    _collectionView.collectionViewLayout = layout;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UICollectionViewDataSource
//create collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}
//define
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.typeImageView.image = [UIImage imageNamed:@""];
    cell.nameLabel.text = @"";
    cell.normalImage = [UIImage imageNamed:@""];
    cell.selectedImage = [UIImage imageNamed:@""];
    cell.selectedLabelColor = [UIColor redColor];
    return cell;
}

#pragma mark -- UICollectionViewDelegate

@end
