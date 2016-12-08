//
//  ChapterViewController.m
//  BQG
//
//  Created by jaycechen on 2016/12/8.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "ChapterViewController.h"

#define kCellInditify @"cellIndify"

@interface ChapterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleList;
@property (weak, nonatomic) id<SelectChapterDelegate> delegate;

@end

@implementation ChapterViewController

- (instancetype)initWithChapterList:(NSArray *)chapterList andDelegate:(id<SelectChapterDelegate>)delegate {
    
    if (self = [super init]) {
        _titleList = chapterList;
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellInditify];
    [self.view addSubview:_tableView];
}

- (NSArray *)titleList {
    
    if (!_titleList) {
        _titleList = [NSArray new];
    }
    return _titleList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellInditify];
    [cell.textLabel setText:self.titleList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onSelectChapter:)]) {
        [_delegate onSelectChapter:indexPath.row];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
