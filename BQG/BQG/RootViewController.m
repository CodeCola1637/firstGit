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

typedef enum : NSUInteger {
    CurrentState_Normal=0,
    CurrentState_Delete,
    CurrentState_Num,
} CurrentState;

@interface RootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CurrentState _state;
}

@property (strong, nonatomic) NSArray<LocalBookModel *> *bookList;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation RootViewController

- (instancetype)init {
    
    if (self = [super init]) {
        _state = CurrentState_Normal;
        [self _refreshBookList];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationItem setTitle:@"Jayce的书架"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(onClickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
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
- (void)onClickLeftItem:(id)sender {
    
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    
    if (CurrentState_Normal == _state) {
        
        _state = CurrentState_Delete;
        [item setTitle:@"取消"];
    } else {
        _state = CurrentState_Normal;
        [item setTitle:@"删除"];
    }
    [self.collectionView reloadData];
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
    if (CurrentState_Delete == _state) {
        [cell setBackgroundColor:[UIColor orangeColor]];
    } else {
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LocalBookModel *model = self.bookList[indexPath.row];
    if (CurrentState_Normal == _state) {
        TextViewController *controller = [[TextViewController alloc] initWithBookNum:model.bookNum];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"认真@真"
                                                                       message:[NSString stringWithFormat:@"确认删除 %@ 吗？", model.bookName]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  [self _deleteBook:model];
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                                  [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                              }];
        [alert addAction:confirmAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - private
- (void)_refreshBookList {
    _bookList = [LogicServiceInstance.localDataService getBookList];
    [self.collectionView reloadData];
}

- (void)_deleteBook:(LocalBookModel *)model {
    
    [LogicServiceInstance.localDataService deleteBookFromList:model.bookNum];
    NSMutableArray *array = [NSMutableArray arrayWithArray:_bookList];
    [array removeObject:model];
    _bookList = array;
}

@end
