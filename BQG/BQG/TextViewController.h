//
//  TextViewController.h
//  BQG
//
//  Created by jaycechen on 2016/12/8.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController

- (instancetype)initWithBookNum:(NSString *)bookNum;
- (void)seekToIndex:(NSInteger)index;

@end
