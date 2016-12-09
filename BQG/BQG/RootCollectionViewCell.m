//
//  RootCollectionViewCell.m
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "RootCollectionViewCell.h"

@implementation RootCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self _setUpUI];
    }
    return self;
}

- (void)_setUpUI {
    
    _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_titleLabel];
}

@end
