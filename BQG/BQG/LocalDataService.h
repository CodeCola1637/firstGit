//
//  LocalDataService.h
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalBookModel.h"
#import "GlobalDefine.h"

@interface LocalDataService : NSObject

TCSingletonInterface(LocalDataService);

- (NSArray<LocalBookModel *> *)getBookList;
- (void)addBookToList:(NSString *)bookNum bookName:(NSString *)bookName;
- (void)deleteBookFromList:(NSString *)bookNum;
- (NSInteger)getHistoryIndexForBook:(NSString *)bookNum;
- (void)updateIndex:(NSInteger)index toBook:(NSString *)bookNum;

@end
