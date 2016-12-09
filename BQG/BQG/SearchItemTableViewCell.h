//
//  SearchItemTableViewCell.h
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchItemModel.h"

@protocol ChooseBook <NSObject>

- (void)onChooseBook:(NSString *)bookNum andName:(NSString *)bookName;

@end

@interface SearchItemTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ChooseBook> chooseDelegate;

- (void)renderWithModel:(SearchItemModel *)model;

@end
