//
//  LogicService.h
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookService.h"
#import "SearchService.h"
#import "LocalDataService.h"

#define LogicServiceInstance    [LogicService shareInstance]

@interface LogicService : NSObject

+ (LogicService *)shareInstance;

- (BookService *)bookService;
- (SearchService *)searchService;
- (LocalDataService *)localDataService;

@end
