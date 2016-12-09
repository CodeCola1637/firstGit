//
//  SearchItemTableViewCell.m
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "SearchItemTableViewCell.h"

@implementation SearchItemTableViewCell
{
    UILabel *_titleLabel;
    UILabel *_descLabel;
    UILabel *_infoLabel;
    UIButton *_addBtn;
    SearchItemModel *_model;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self _setUpUI];
    }
    return self;
}

- (void)_setUpUI {
    
    _titleLabel = [UILabel new];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
    [self.contentView addSubview:_titleLabel];
    
    _descLabel = [UILabel new];
    [_descLabel setTextAlignment:NSTextAlignmentCenter];
    [_descLabel setNumberOfLines:0];
    [_descLabel setFont:[UIFont systemFontOfSize:15.f]];
    [self.contentView addSubview:_descLabel];
    
    _infoLabel = [UILabel new];
    [_infoLabel setTextAlignment:NSTextAlignmentCenter];
    [_infoLabel setNumberOfLines:0];
    [_infoLabel setFont:[UIFont systemFontOfSize:15.f]];
    [self.contentView addSubview:_infoLabel];
    
    [_titleLabel setFrame:CGRectMake(0, 5, self.contentView.bounds.size.width, 20)];
    [_descLabel setFrame:CGRectMake(0, 30, self.contentView.bounds.size.width, 55)];
    [_infoLabel setFrame:CGRectMake(0, 90, self.contentView.bounds.size.width, 90)];
    
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width-55, 0, 50, 25)];
    [_addBtn setBackgroundColor:[UIColor greenColor]];
    [_addBtn setTitle:@"临幸" forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(onClickChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addBtn];
    
    [_titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_descLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_infoLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_addBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
}

- (void)renderWithModel:(SearchItemModel *)model {
    
    _model = model;
    [_titleLabel setText:model.title];
    [_descLabel setText:model.desc];
    [_infoLabel setText:[self _convertDicToString:model.infoDic]];
}

- (NSString *)_convertDicToString:(NSDictionary *)dic {
    
    NSString *str = @"";
    
    for (NSString *key in [dic allKeys]) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n", key, dic[key]]];
    }
    return str;
}

- (void)onClickChooseBtn:(id)sender {
    
    if (_chooseDelegate && [_chooseDelegate respondsToSelector:@selector(onChooseBook:andName:)]) {
        [_chooseDelegate onChooseBook:_model.bookNum andName:_model.title];
        [sender setHidden:YES];
    }
}

@end
