//
//  TopPopView.m
//  jiechu
//
//  Created by jianxd on 15/1/8.
//  Copyright (c) 2015年 jiechu. All rights reserved.
//

#import "TopPopView.h"
#import "PopTableViewCell.h"
#import "PopCollectionViewCell.h"
#import <POP.h>

@interface TopPopView ()
<UITableViewDataSource,
UITableViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate>

@property (strong, nonatomic) UIView *wrapView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

static NSString *tableCellReuseIndentifier = @"tableCell";
static NSString *collectionCellReuseIndentifier = @"collectionCell";
@implementation TopPopView

- (instancetype)initWithViewType:(PopViewType)viewType {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.viewType = viewType;
        [self configViews];
        if (viewType == PopViewTypeGrid) {
            [self configCollectionView];
        } else {
            [self configTableView];
        }
    }
    return self;
}

- (void)configViews {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [self addGestureRecognizer:tapRecognizer];
    UIView *wrapView = [[UIView alloc] init];
//    wrapView.backgroundColor = RGBACOLOR(184.0, 150.0, 101.0, 0.8);
    [self addSubview:wrapView];
    self.wrapView = wrapView;
}

- (void)configTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [_wrapView addSubview:tableView];
    self.tableView = tableView;
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(40.0, 40.0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    [_wrapView addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)tapBackground:(UITapGestureRecognizer *)tapRecognizer {
    [self hide];
}

- (void)showInView:(UIView *)view {
    CGRect frame = view.bounds;
    [view addSubview:self];
    self.frame = frame;
    if (_viewType == PopViewTypeGrid) {
        
    } else {
        CGFloat contentHeight;
        if ([_delegate respondsToSelector:@selector(numberOfItemsInPopView:)]) {
            NSInteger count = [_delegate numberOfItemsInPopView:self];
            contentHeight = count * [PopTableViewCell cellHeight];
            contentHeight = MIN(contentHeight, 200.0);
        }
        _wrapView.frame = CGRectMake(0.0, -contentHeight, CGRectGetWidth(self.bounds), contentHeight);
        _tableView.frame = _wrapView.bounds;
        
    }
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0.0, -CGRectGetHeight(_wrapView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(_wrapView.frame))];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(_wrapView.frame))];
    animation.springBounciness = 6.0;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        self.shown = YES;
    }];
    [_wrapView pop_addAnimation:animation forKey:@"show"];
}

- (void)hide {
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(_wrapView.frame))];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0.0, -CGRectGetHeight(_wrapView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(_wrapView.frame))];
    animation.springBounciness = 6.0;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        self.shown = NO;
        [self removeFromSuperview];
    }];
    [_wrapView pop_addAnimation:animation forKey:@"hide"];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if ([_delegate respondsToSelector:@selector(numberOfItemsInPopView:)]) {
        number = [_delegate numberOfItemsInPopView:self];
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellReuseIndentifier];
    if (cell == nil) {
        cell = [[PopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellReuseIndentifier];
    }
    UIImage *image = nil;
    if ([_delegate respondsToSelector:@selector(popView:imageAtIndex:)]) {
        image = [_delegate popView:self imageAtIndex:indexPath.row];
    }
    NSString *title = nil;
    if ([_delegate respondsToSelector:@selector(popView:titleAtIndex:)]) {
        title = [_delegate popView:self titleAtIndex:indexPath.row];
    }
    cell.iconImageView.image = image;
    cell.nameLabel.text = title;
    return cell;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedIndex != indexPath.row) {
        if ([_delegate respondsToSelector:@selector(popView:didSelectItemAtIndex:)]) {
            self.selectedIndex = indexPath.row;
            [_delegate popView:self didSelectItemAtIndex:indexPath.row];
        }
    }
    [self hide];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PopTableViewCell cellHeight];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellReuseIndentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark -- UICollectionViewDelegate

@end
