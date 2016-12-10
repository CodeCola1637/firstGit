//
//  ChapterViewController.m
//  BQG
//
//  Created by jaycechen on 2016/12/8.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "ChapterViewController.h"

#define kCellInditify @"cellIndify"

typedef enum : NSUInteger {
    Order_OldFirst = 0,
    Order_NewFirst,
    Order_Num,
} Order;

@interface ChapterViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    Order _currentOrder;
    NSIndexPath *_firstIndexPath;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleList;
@property (weak, nonatomic) id<SelectChapterDelegate> delegate;

@end

@implementation ChapterViewController

- (instancetype)initWithChapterList:(NSArray *)chapterList currentIndex:(NSInteger)index andDelegate:(id<SelectChapterDelegate>)delegate {
    
    if (self = [super init]) {
        
        _currentOrder = Order_OldFirst;
        _firstIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        _titleList = chapterList;
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"倒序" style:UIBarButtonItemStyleDone target:self action:@selector(onClickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellInditify];
    [self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [_tableView scrollToRowAtIndexPath:_firstIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (NSArray *)titleList {
    
    if (!_titleList) {
        _titleList = [NSArray new];
    }
    return _titleList;
}

#pragma mark - UITableView DataSource|Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellInditify];
    [cell.textLabel setText:[self _getTitleForIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = Order_OldFirst == _currentOrder ? indexPath.row : self.titleList.count-indexPath.row-1;
    if (_delegate && [_delegate respondsToSelector:@selector(onSelectChapter:)]) {
        [_delegate onSelectChapter:index];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions
- (void)onClickRightItem:(id)sender {
    
    UIBarButtonItem *rightItem = sender;
    if (Order_OldFirst == _currentOrder) {
        
        _currentOrder = Order_NewFirst;
        [rightItem setTitle:@"正序"];
    } else {
        
        _currentOrder = Order_OldFirst;
        [rightItem setTitle:@"倒序"];
    }
    [self.tableView reloadData];
}

#pragma mark - Private
- (NSString *)_getTitleForIndexPath:(NSIndexPath *)indexpath {
    
    NSString *title;
    if (Order_OldFirst == _currentOrder) {
        
        title = self.titleList[indexpath.row];
    } else {
        
        title = self.titleList[self.titleList.count-1-indexpath.row];
    }
    return title;
}

@end
