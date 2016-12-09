//
//  SearchItemModel.h
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchItemModel : NSObject

@property (strong, nonatomic) NSString *bookNum;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSDictionary *infoDic;

@end
