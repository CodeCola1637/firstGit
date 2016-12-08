//
//  RootViewController.m
//  BQG
//
//  Created by jaycechen on 2016/12/8.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "RootViewController.h"
#import "TextViewController.h"

@interface RootViewController ()

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onClickBtn:(id)sender {
    
    TextViewController *controller = [[TextViewController alloc] initWithBookNum:@"43821"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
