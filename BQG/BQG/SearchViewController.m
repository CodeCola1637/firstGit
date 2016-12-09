//
//  SearchViewController.m
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "SearchViewController.h"
#import "TextViewController.h"
#import "SearchItemTableViewCell.h"

#import "LogicService.h"

#define kSearchCellIdentify @"SearchCell"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, ChooseBook>
{
    uint32_t _currentSearchIndex;
}
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *searchBtn;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *searchItemList;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width-70, 30)];
    [_textField setPlaceholder:@"请输入小说／作者名"];
    [self.view addSubview:_textField];
    
    _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-60, 5, 50, 30)];
    [_searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [_searchBtn setBackgroundColor:[UIColor greenColor]];
    [_searchBtn addTarget:self action:@selector(onClickSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40) style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[SearchItemTableViewCell class] forCellReuseIdentifier:kSearchCellIdentify];
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_textField becomeFirstResponder];
}

- (NSArray *)searchItemList {
    
    if (!_searchItemList) {
        _searchItemList = [NSArray new];
    }
    return _searchItemList;
}

#pragma mark - Actions
- (void)onClickSearch:(id)sender {
    
    [self.textField resignFirstResponder];
    
    _currentSearchIndex = 0;
    _searchItemList = [LogicServiceInstance.searchService searchKeyWord:_textField.text andPageIndex:_currentSearchIndex];
    [self.tableView reloadData];
}

- (void)onSearchNextPage:(id)sender {
    
    _currentSearchIndex += 1;
    _searchItemList =[_searchItemList arrayByAddingObjectsFromArray:[LogicServiceInstance.searchService searchKeyWord:_textField.text andPageIndex:_currentSearchIndex]];
    [self.tableView reloadData];
}

#pragma mark - TableView DataSource | Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchItemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 180.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCellIdentify];
    cell.chooseDelegate = self;
    [cell renderWithModel:self.searchItemList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchItemModel *model = self.searchItemList[indexPath.row];
    TextViewController *controller = [[TextViewController alloc] initWithBookNum:model.bookNum];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

#pragma mark - ChooseBook

- (void)onChooseBook:(NSString *)bookNum andName:(NSString *)bookName {
    
    [LogicServiceInstance.localDataService addBookToList:bookNum bookName:bookName];
}

@end
