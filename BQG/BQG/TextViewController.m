//
//  TextViewController.m
//  BQG
//
//  Created by jaycechen on 2016/12/8.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "TextViewController.h"
#import "ChapterViewController.h"
#import "LogicService.h"


@interface TextViewController ()<SelectChapterDelegate>
{
    NSString *_bookNum;
    NSArray *_hrefList;
    NSArray *_titleList;
    NSString *_currentText;
    NSInteger _currentIndex;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *preBtn;
@property (strong, nonatomic) UIButton *nextBtn;

@end

@implementation TextViewController

- (instancetype)initWithBookNum:(NSString *)bookNum {
    
    if (self = [super init]) {
        _bookNum = bookNum;
        [self getChapterList:bookNum];
        [self seekToIndex:[LogicServiceInstance.localDataService getHistoryIndexForBook:bookNum]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:_scrollView];
    
    _contentLabel = [UILabel new];
    [_contentLabel setNumberOfLines:0];
    [_contentLabel setFont:[UIFont systemFontOfSize:15.f]];
    [_contentLabel setTextColor:[UIColor blackColor]];
    [_scrollView addSubview:_contentLabel];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"目录" style:UIBarButtonItemStyleDone target:self action:@selector(onClickChapter:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _preBtn = [UIButton new];
    [_preBtn setBackgroundColor:[UIColor grayColor]];
    [_preBtn setTitle:@"上一章" forState:UIControlStateNormal];
    [_preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_preBtn setFrame:CGRectMake(0, self.view.bounds.size.height/2-25, 100, 50)];
    [_preBtn addTarget:self action:@selector(onClickPreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_preBtn];
    
    _nextBtn = [UIButton new];
    [_nextBtn setBackgroundColor:[UIColor grayColor]];
    [_nextBtn setTitle:@"下一章" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setFrame:CGRectMake(self.view.bounds.size.width-100, self.view.bounds.size.height/2-25, 100, 50)];
    [_nextBtn addTarget:self action:@selector(onClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    [_preBtn setHidden:YES];
    [_nextBtn setHidden:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMenu:)];
    [_scrollView addGestureRecognizer:tapGesture];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [LogicServiceInstance.localDataService updateIndex:_currentIndex toBook:_bookNum];
}

- (void)seekToIndex:(NSInteger)index {
    
    [self.navigationItem setTitle:_titleList[index]];
    
    _currentIndex = index;
    _currentText = [self getStringForIndex:index];

    CGSize labelSize=[_currentText boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _contentLabel.font} context:nil].size;
    [_scrollView setContentSize:labelSize];
    [_contentLabel setFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    [_contentLabel setText:_currentText];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - Event
- (void)onClickChapter:(id)sender {
    
    ChapterViewController *controller = [[ChapterViewController alloc] initWithChapterList:_titleList andDelegate:self];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickPreBtn:(id)sender {
    
    [self seekToIndex:_currentIndex-1];
    [self changeMenuStatus];
}

- (void)onClickNextBtn:(id)sender {
    
    [self seekToIndex:_currentIndex+1];
    [self changeMenuStatus];
}

- (void)onTapMenu:(id)sender {
    
    if (_currentIndex == 0) {
        [_preBtn setEnabled:NO];
        [_preBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        [_preBtn setEnabled:YES];
        [_preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (_currentIndex == _hrefList.count-1) {
        [_nextBtn setEnabled:NO];
        [_nextBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        [_nextBtn setEnabled:YES];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [self changeMenuStatus];
}

#pragma mark - SelectChapterDelegate
- (void)onSelectChapter:(NSInteger)index {
    
    [self seekToIndex:index];
}

#pragma mark - private
- (NSString *)getStringForIndex:(NSInteger)index {
    
    return [[BookService shareInstance] getBookContent:_hrefList[index]];
}

- (void)getChapterList:(NSString *)bookNum {
    
    // 阻塞的操作
    [[BookService shareInstance] getBookChapterList:bookNum andCompleteBlock:^(NSArray *hrefList, NSArray *titleList) {
        _hrefList = hrefList;
        _titleList = titleList;
    }];
}

- (void)changeMenuStatus {
    
    [_preBtn setHidden:!_preBtn.hidden];
    [_nextBtn setHidden:!_nextBtn.hidden];
    [_scrollView setScrollEnabled:!_scrollView.scrollEnabled];
}

@end
