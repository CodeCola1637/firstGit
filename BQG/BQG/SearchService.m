//
//  SearchService.m
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "SearchService.h"
#import "HtmlAnalyzeUtil.h"

#define kSearchUrlFormat  @"http://zhannei.baidu.com/cse/search?q=%@&p=%d&s=287293036948159515"

@implementation SearchService

+ (SearchService *)shareInstance {
    
    static SearchService *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SearchService alloc] init];
    });
    return shareInstance;
}

- (NSArray<SearchItemModel *> *)searchKeyWord:(NSString *)keyword andPageIndex:(uint32_t)index {
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!$&'()*+,-./:;=?@_~%#[]"];
    NSString *finalKeyword = [keyword stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *url = [NSString stringWithFormat:kSearchUrlFormat, finalKeyword, index];
    NSString *content = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *components = [content componentsSeparatedByString:@"<div class=\"result-item result-game-item\">"];
    
    NSMutableArray *retArray = [NSMutableArray new];
    for (int i=1; i<components.count; i++) {
        [retArray addObject:[self _analyzeHtmlStr:components[i]]];
    }
    return retArray;
}

- (SearchItemModel *)_analyzeHtmlStr:(NSString *)htmlStr {
    
    SearchItemModel *model = [SearchItemModel new];
    NSString *titleComponent = [HtmlAnalyzeUtil getElementFromTag:@"<h3 class=\"result-item-title result-game-item-title\">" toTag:@"</h3>" html:htmlStr];
    NSString *hrefStr = [HtmlAnalyzeUtil getElementFromTag:@"<a cpos=\"title\" href=\"" toTag:@"\"" html:titleComponent];
    NSString *title = [HtmlAnalyzeUtil getElementFromTag:@"title=\"" toTag:@"\"" html:titleComponent];
    model.bookNum = [[[hrefStr lastPathComponent] componentsSeparatedByString:@"_"] lastObject];
    model.title = title;
    model.desc = [HtmlAnalyzeUtil getElementFromTag:@"<p class=\"result-game-item-desc\">" toTag:@"</p>" html:htmlStr];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *infoStr = [HtmlAnalyzeUtil getElementFromTag:@"<div class=\"result-game-item-info\">" toTag:@"</div>" html:htmlStr];
    NSArray *infoComponents = [infoStr componentsSeparatedByString:@"<p class=\"result-game-item-info-tag\">"];
    
    for (int i=1; i<infoComponents.count; i++) {
        NSArray *detailComponents = [infoComponents[i] componentsSeparatedByString:@"</span>"];
        NSString *key = [HtmlAnalyzeUtil getElementFromTag:@">" toTag:@"<" html:detailComponents[0]];
        NSString *value = [HtmlAnalyzeUtil getElementFromTag:@">" toTag:@"<" html:detailComponents[1]];
        [dic setObject:[self removeBackTabAndSpace:value] forKey:[self removeBackTabAndSpace:key]];
    }
    
    model.infoDic = dic;
    return model;
}

- (NSString *)removeBackTabAndSpace:(NSString *)originStr {
    
    NSString *noSpaceStr = [originStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *noTabSpaceStr = [noSpaceStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *noTabSpaceBackStr = [noTabSpaceStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    noTabSpaceBackStr = [noTabSpaceBackStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return noTabSpaceBackStr;
}

@end
