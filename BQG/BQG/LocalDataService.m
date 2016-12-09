//
//  LocalDataService.m
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "LocalDataService.h"

#define bookListKey @"booklist_key"
#define userDefault [NSUserDefaults standardUserDefaults]

@implementation LocalDataService

TCSingletonImp(LocalDataService);

- (void)addBookToList:(NSString *)bookNum bookName:(NSString *)bookName {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:bookListKey]];
    if ([dic.allKeys containsObject:bookNum]) {
        return;
    }
    [dic setObject:bookName forKey:bookNum];
    [userDefault setObject:dic forKey:bookListKey];
}

- (void)deleteBookFromList:(NSString *)bookNum {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:bookListKey]];
    if (![dic.allKeys containsObject:bookNum]) {
        return;
    }
    
    [dic removeObjectForKey:bookNum];
    [userDefault removeObjectForKey:bookNum];
    [userDefault setObject:dic forKey:bookListKey];
}

- (NSArray<LocalBookModel *> *)getBookList {
    
    NSMutableArray *array = [NSMutableArray new];
    NSDictionary *dic = [userDefault objectForKey:bookListKey];
    for (NSString *key in [dic allKeys]) {
        LocalBookModel *model = [LocalBookModel new];
        model.bookNum = key;
        model.bookName = dic[key];
        [array addObject:model];
    }
    return array;
}

- (NSInteger)getHistoryIndexForBook:(NSString *)bookNum {
    
    return [[userDefault objectForKey:bookNum] integerValue];
}

- (void)updateIndex:(NSInteger)index toBook:(NSString *)bookNum {
    
    [userDefault setObject:@(index) forKey:bookNum];
}

@end
