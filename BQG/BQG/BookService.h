//
//  BookService.h
//  BQG
//
//  Created by jaycechen on 2016/12/8.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BookChapterBlock)(NSArray *, NSArray *);

@interface BookService : NSObject

+ (BookService *)shareInstance;
- (void)getBookChapterList:(NSString *)bookNum andCompleteBlock:(BookChapterBlock)block;
- (NSString *)getBookContent:(NSString *)hrefStr;

@end
