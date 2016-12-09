//
//  LogicService.m
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "LogicService.h"

@implementation LogicService

+ (LogicService *)shareInstance {
    
    static LogicService *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[LogicService alloc] init];
    });
    return shareInstance;
}

- (BookService *)bookService {
    return [BookService shareInstance];
}

- (SearchService *)searchService {
    
    return [SearchService shareInstance];
}

- (LocalDataService *)localDataService {
    
    return [LocalDataService shareInstance];
}

@end
