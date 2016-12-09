//
//  RootViewController.m
//  BQG
//
//  Created by jaycechen on 2016/12/8.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "RootViewController.h"
#import "TextViewController.h"
#import "SearchViewController.h"
#import "RootCollectionViewCell.h"

#import "LogicService.h"

#define kRootCollectionIdentify @"kRootCollectionIdentify"

@interface RootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray<LocalBookModel *> *bookList;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation RootViewController

- (instancetype)init {
    
    if (self = [super init]) {
        [self _refreshBookList];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"查找" style:UIBarButtonItemStyleDone target:self action:@selector(onClickSearch:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setMinimumLineSpacing:2.f];
    [layout setMinimumInteritemSpacing:2.f];
    CGFloat singLine = self.view.bounds.size.width/2 - 1;
    [layout setItemSize:CGSizeMake(singLine, singLine)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_collectionView registerClass:[RootCollectionViewCell class] forCellWithReuseIdentifier:kRootCollectionIdentify];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self _refreshBookList];
}

- (NSArray<LocalBookModel *> *)bookList {
    
    if (!_bookList) {
        _bookList = [NSArray new];
    }
    return _bookList;
}

#pragma mark - actions
- (void)onClickBtn:(id)sender {
    
    TextViewController *controller = [[TextViewController alloc] initWithBookNum:@"43821"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickSearch:(id)sender {
    
    SearchViewController *controller = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UICollectionView DataSource | Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.bookList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRootCollectionIdentify forIndexPath:indexPath];
    LocalBookModel *model = self.bookList[indexPath.row];
    [cell.titleLabel setText:model.bookName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LocalBookModel *model = self.bookList[indexPath.row];
    TextViewController *controller = [[TextViewController alloc] initWithBookNum:model.bookNum];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - private
- (void)_refreshBookList {
    _bookList = [LogicServiceInstance.localDataService getBookList];
    [self.collectionView reloadData];
}

@end
