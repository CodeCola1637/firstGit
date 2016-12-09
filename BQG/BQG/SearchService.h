//
//  SearchService.h
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchItemModel.h"

@interface SearchService : NSObject

+ (SearchService *)shareInstance;

- (NSArray<SearchItemModel *> *)searchKeyWord:(NSString *)keyword andPageIndex:(uint32_t)index;

@end
