//
//  BookService.m
//  BQG
//
//  Created by jaycechen on 2016/12/8.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "BookService.h"
#import "HtmlAnalyzeUtil.h"
#define kBQGUrl @"http://m.biquge.com"

@implementation BookService

+ (BookService *)shareInstance {
    
    static BookService *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[BookService alloc] init];
    });
    return shareInstance;
}

- (void)getBookChapterList:(NSString *)bookNum andCompleteBlock:(BookChapterBlock)block {
    
    if (!block) {
        return;
    }
    
    NSString *getUrl = [kBQGUrl stringByAppendingString:[NSString stringWithFormat:@"/booklist/%@.html", bookNum]];
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:getUrl] encoding:NSUTF8StringEncoding error:nil];

    NSString *content = [HtmlAnalyzeUtil getElementFromTag:@"<ul class=\"chapter\">" toTag:@"</ul>" html:string];
    NSArray *array = [content componentsSeparatedByString:@"<li>"];
    
    NSMutableArray *hrefList = [NSMutableArray new];
    NSMutableArray *strList = [NSMutableArray new];
    
    for (int i=1; i<array.count; i++) {
        NSString *combineStr = [HtmlAnalyzeUtil getElementFromTag:@"<a href=\"" toTag:@"</a>" html:array[i]];
        NSArray *tempArray = [combineStr componentsSeparatedByString:@"\">"];
        [hrefList addObject:tempArray[0]];
        [strList addObject:tempArray[1]];
    }
    
    block(hrefList, strList);
}

- (NSString *)getBookContent:(NSString *)hrefStr {
    
    NSString *getUrl = [kBQGUrl stringByAppendingString:hrefStr];
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:getUrl] encoding:NSUTF8StringEncoding error:nil];
    
    NSString *content = [HtmlAnalyzeUtil getElementFromTag:@"<div id=\"nr1\">" toTag:@"</div>" html:string];
    NSString *tempContent = [content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    NSString *realContent = [tempContent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return realContent;
}



@end
